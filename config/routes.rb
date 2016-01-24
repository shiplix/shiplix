require "resque_web"

Rails.application.routes.draw do
  mount ResqueWeb::Engine => "/resque_web"

  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  # NOTE: we need build path without resources and use *id instead :id becouse
  # rails escape slash in url helpers, eg repo_path(repo) renders as user_name%2Frepo_name
  # instead user_name/repo_name
  scope :repos do
    scope "*repo_id", as: :repo do
      resources :branches, only: [] do
        resources :blocks, only: :index
      end

      resources :builds, only: [] do
        resources :blocks, only: :index

        scope module: "blocks" do
          resources :namespaces, only: :show
          get "files/*id", to: "files#show", as: :file, constraints: {id: /.*/}
        end
      end
    end

    get "*id", to: "repos#show", as: :repo
    get "/", to: "repos#index", as: :repos
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
