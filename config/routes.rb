Rails.application.routes.draw do
  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resource :user, only: [:index]
  resources :repos, only: [:index]
  resources :repo_syncs, only: [:create]

  root 'users#index'
end
