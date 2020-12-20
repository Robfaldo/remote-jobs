Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # root 'active_jobs#index'
  post '/create_job' => "create_job#create"
  get '/search' => "search#index"
  root 'live_jobs#index'
end
