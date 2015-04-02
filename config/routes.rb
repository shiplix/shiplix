Rails.application.routes.draw do
  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :jobs, only: [:show]

  resources :repos, only: [:index, :show] do
    resources :klasses, only: [:index, :show]
    resources :source_files, only: [:index]
  end

  resources :builds, only: :create

  resources :repo_syncs, only: [:create]
  resources :repo_activations, only: [:update, :destroy]
  resources :github_events, only: [:create]

  root 'home#index'

  match '*path', to: 'application#catch_404', via: :all
end
