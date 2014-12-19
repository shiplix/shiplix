Rails.application.routes.draw do
  get '/auth/github/callback', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'

  resource :user, only: [:index]

  root 'users#index'
end
