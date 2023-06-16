Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    # For sign out button after adding OmniAuth: https://stackoverflow.com/a/30095074/5615805
    get '/users/sign_out' => 'devise/sessions#destroy'

    # See https://github.com/heartcombo/devise/issues/4573#issuecomment-445018377. Workaround for clicking refresh after failed registration
    get '/users', to: 'devise/registrations#new'
  end

  namespace :api, defaults: { format: :json }  do
    namespace :v1 do
      resources :jobs, only: [:create]
      resources :live_jobs, only: [:index]
    end
  end
end
