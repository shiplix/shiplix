require "resque_web"

Rails.application.routes.draw do
  mount ResqueWeb::Engine => "/resque_web"

  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resources :jobs, only: [:show]

  # NOTE: we need build path without resources and use *id instead :id becouse
  # rails escape slash in url helpers, eg repo_path(repo) renders as user_name%2Frepo_name
  # instead user_name/repo_name
  scope :repos do
    get '*repo_id/blocks', to: 'blocks#index', as: :repo_blocks

    scope module: "blocks" do
      get '*repo_id/namespaces/:id', to: 'namespaces#show', as: :repo_namespace
      get '*repo_id/files/:id', to: 'files#show', as: :repo_file
    end

    get '*id', to: 'repos#show', as: :repo
    get '/', to: 'repos#index', as: :repos
  end

  resources :builds, only: :create

  resources :repo_syncs, only: [:create]
  resources :repo_activations, only: [:update, :destroy]
  resources :github_events, only: [:create]

  get "/*id", to: 'pages#show', as: :page, format: false
  root 'home#index'

  match '*path', to: 'application#catch_404', via: :all
end
