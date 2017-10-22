Rails.application.routes.draw do
  root to: 'organizations#index'

  resources :user_sessions, only: [:create, :destroy]
  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  get '/sign_in', to: 'user_sessions#new', as: :sign_in

  resources :organizations
  resources :users
  resources :roles
  resources :role_members
  resources :rights
end
