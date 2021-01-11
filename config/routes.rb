Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'live_jobs#index'
  get '/search' => "search#index"
  get '/stats' => 'scraping_stats#index'
  get '/rejected' => 'rejected_jobs#index'
  get '/jobs_secret' => 'jobs#index'
  get '/jobs_secret_approved' => 'approved_jobs#index'
  get '/source_links' => 'source_links#index'
  resources :jobs, only: [:update]
end
