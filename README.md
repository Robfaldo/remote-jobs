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
AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')
```

# Omniauth 

We allow users to sign in using omniauth. List of [strategies](https://github.com/omniauth/omniauth/wiki/List-of-Strategies) for what omniauths are available. 

We currently use [GoogleOAuth2](https://github.com/zquestz/omniauth-google-oauth2) 
and I set this up following [this guide](https://medium.com/@adamlangsner/google-oauth-rails-5-using-devise-and-omniauth-1b7fa5f72c8e).
