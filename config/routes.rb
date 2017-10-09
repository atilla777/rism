Rails.application.routes.draw do
  root to: 'organizations#index'

  resources :organizations
end
