Rails.application.routes.draw do
  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :jobs, only: [:show]

  resource :user, only: [:index]
  resources :repos, only: [:index]
  resources :repo_syncs, only: [:create]
  resources :repo_activations, only: [:create]

  root 'users#index'
end
