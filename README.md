# README

##Getting started
```
bundle install 
rake db:migrate
rake db:seed # for activeadmin
```

## Rails Admin

We use [Rails Admin](https://activeadmin.info/documentation.html) for the backend. 

You can log in by going to http://localhost:3000/admin
```
## Creating admin account in production 
heroku run bundle exec rails c
Admin.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')
```

# Omniauth 

We allow users to sign in using omniauth. List of [strategies](https://github.com/omniauth/omniauth/wiki/List-of-Strategies) for what omniauths are available. 

We currently use [GoogleOAuth2](https://github.com/zquestz/omniauth-google-oauth2) 
and I set this up following [this guide](https://medium.com/@adamlangsner/google-oauth-rails-5-using-devise-and-omniauth-1b7fa5f72c8e).

# Delivering emails 

To enable emails to be sent in development env go to `config/environments/development.rb` 
and change `config.action_mailer.perform_deliveries` to `true`

By default production uses GoDaddy (set up follow [these instructions](https://medium.com/@rachelchervin/sending-emails-with-godaddy-and-ruby-on-rails-fc503a45af10)) and 
development uses gmail. 

# Error handling

To get Sentry to fire events in development environment you need to go into `application.yml` and comment out `SENTRY_DSN`.

To start Sentry firing events, either you do the opposite of above or just pass that env variable when starting the app (`SENTRY_DSN='sentry_dsn_goes_here'`)

FYI the 'additional info' that we send with error messages will be saved as tags in sentry (see below): 

![img.png](img.png)

For Rollbar you can go into the rollbar initializer and there's a section to comment out, there's a note next to it. 

# Sidekiq for queuing 

Originally when scraping jobs we ran a bunch of scrapers running concurrently and just 
saved the jobs as each process was finished. This was a problem because you can only 
access the database with 5 connections at once, and it was trying to save too many jobs at the 
same time which resulted in a `ActiveRecord::ConnectionTimeoutError` error and [this nifty piece of code](https://github.com/Robfaldo/remote-jobs/blob/3922537229020f3a77f116ddb500ea27faf03251/app/services/scraping/default_scraper.rb#L114-L125).

To avoid this problem we use sidekiq to queue the jobs we want to create and limit the number 
of jobs that are making calls to the database. 

If you look in `sidekiq.yml` you can see that we have create a queue for jobs that make calls to 
database and we also limit the number of concurrent processes that can run at once for this queue.

Gotcha to avoid: remember to use `perform_later` when invoking the sidekiq worker. `perform_now` won't 
abide by the concurrency limit rules. 
