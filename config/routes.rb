Rails.application.routes.draw do
  root to: 'organizations#index'

  resources :user_sessions, only: [:create, :destroy]
  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  get '/sign_in', to: 'user_sessions#new', as: :sign_in


  resources :organizations do
    get :autocomplete_organization_name, :on => :collection
  end

  resources :users
  post '/departments/select', to: 'departments#select', as: :departments_select
  put '/departments/paste', to: 'departments#paste', as: :departments_paste
  get '/departments/reset', to: 'departments#reset', as: :departments_reset
  resources :roles
  resources :role_members
  resources :rights
  resources :departments
end
