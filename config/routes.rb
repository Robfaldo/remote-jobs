Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'live_jobs#index'
  get '/stats' => 'scraping_stats#index'
  get '/rejected' => 'rejected_jobs#index'
  get '/jobs_secret' => 'jobs#index'
  get '/source_links' => 'source_links#index'
  resources :jobs, only: [:update]
  # get '/search' => "search#index"
end
