Rails.application.routes.draw do
  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :jobs, only: [:show]

  # NOTE: we need build path without resources and use *id instead :id becouse
  # rails escape slash in url helpers, eg repo_path(repo) renders as user_name%2Frepo_name
  # instead user_name/repo_name
  scope :repos do
    get '*repo_id/classes', to: 'klasses#index', as: :repo_klasses
    get '*repo_id/classes/:id', to: 'klasses#show', as: :repo_klass

    get '*repo_id/files', to: 'source_files#index', as: :repo_source_files

    get '*id', to: 'repos#show', as: :repo
    get '/', to: 'repos#index', as: :repos
  end

  resources :builds, only: :create

  resources :repo_syncs, only: [:create]
  resources :repo_activations, only: [:update, :destroy]
  resources :github_events, only: [:create]

  root 'home#index'

  match '*path', to: 'application#catch_404', via: :all
end
