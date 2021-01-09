Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'live_jobs#index'
  get '/search' => "search#index"
  get '/stats' => 'scraping_stats#index'
  get '/rejected' => 'rejected_jobs#index'
  get '/jobs_secret' => 'jobs#index'
  get '/source_links' => 'source_links#index'
  resources :jobs, only: [:update]
end
