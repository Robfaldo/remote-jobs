Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    # For sign out button after adding OmniAuth: https://stackoverflow.com/a/30095074/5615805
    get '/users/sign_out' => 'devise/sessions#destroy'

    # See https://github.com/heartcombo/devise/issues/4573#issuecomment-445018377. Workaround for clicking refresh after failed registration
    get '/users', to: 'devise/registrations#new'
  end

  devise_for :admins

  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      resources :jobs, only: [:create]
    end
  end

  # root 'live_jobs#index'
  root 'placeholder#index'
  get '/stats' => 'scraping_stats#index'
  get '/jobs_secret' => 'jobs#index'
  get '/source_links' => 'source_links#index'
  resources :jobs, only: [:update]
  # get '/search' => "search#index"
end
