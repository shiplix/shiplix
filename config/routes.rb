require "resque_web"

Rails.application.routes.draw do
  mount ResqueWeb::Engine => "/resque_web"

  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  # NOTE: we need build path without resources and use *id instead :id becouse
  # rails escape slash in url helpers, eg repo_path(repo) renders as user_name%2Frepo_name
  # instead user_name/repo_name
  scope :repos do
    scope ":owner_id/:repo_id", as: :repo do
      resources :branches, only: [] do
        resources :files, only: :index
        get "files/*id", to: "files#show", as: :file, constraints: {id: /.*/}
      end
    end

    get ":owner_id/:repo_id", to: "repos#show", as: :repo
    get "/", to: "repos#index", as: :repos
  end

  namespace :profile do
    root to: 'home#index'

    resources :billing, only: [:index] do
      resource :subscription, only: [:new, :create]
    end
  end

  resources :jobs, only: [:show]
  resources :builds, only: :create
  resources :repo_syncs, only: [:create]
  resources :repo_activations, only: [:update, :destroy]
  resources :github_events, only: [:create]

  get "/*id", to: 'pages#show', as: :page, format: false
  root 'home#index'

  match '*path', to: 'application#catch_404', via: :all
end
