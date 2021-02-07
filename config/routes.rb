Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    # # https://medium.com/@adamlangsner/google-oauth-rails-5-using-devise-and-omniauth-1b7fa5f72c8e for omniauth
    # get 'users/sign_in', to: 'users/sessions#new', as: :new_admin_session
    # get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_admin_session

    # See https://github.com/heartcombo/devise/issues/4573#issuecomment-445018377. Workaround for clicking refresh after failed registration
    get '/users', to: 'devise/registrations#new'
  end

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'live_jobs#index'
  get '/stats' => 'scraping_stats#index'
  get '/jobs_secret' => 'jobs#index'
  get '/source_links' => 'source_links#index'
  resources :jobs, only: [:update]
  # get '/search' => "search#index"
end
