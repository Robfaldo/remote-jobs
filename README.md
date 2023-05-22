# README

##Getting started
```
bundle install 
rake db:migrate
rake db:seed
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

We use rollbar https://rollbar.com/robertfaldo/all/items

* You can enable in development by changing the code in config/initializers/rollbar.rb
* You can test it's working in production with `heroku run rake test_rollbar` (make sure the environment is production in rollbar website)

## Monitoring

This app uses New Relic for monitoring. It's under robertfaldo@gmail.com and login details in 1password.

## Admin

This app uses activeadmin for its admin dashboard. You can visit localhost:3000/admin to log in as admin 
and you can see `app/admin/jobs` to customise the dashboard that shows. 
