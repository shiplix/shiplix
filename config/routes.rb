Rails.application.routes.draw do
  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :jobs, only: [:show]

  resources :repos, only: [:index] do
    resources :klasses, only: [:index]
  end

  resources :repo_syncs, only: [:create]
  resources :repo_activations, only: [:update, :destroy]
  resources :github_events, only: [:create]

  root 'home#index'
end
