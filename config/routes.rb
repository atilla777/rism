Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root to: 'organizations#index'

  resources :user_sessions, only: [:create, :destroy]
  delete '/sign_out', to: 'user_sessions#destroy', as: :sign_out
  get '/sign_in', to: 'user_sessions#new', as: :sign_in
  get '/no_roles', to: 'user_sessions#no_roles', as: :no_roles

  resources :organizations do
    get :autocomplete_organization_name, :on => :collection, as: :autocomplete
  end

  resources :users do
    get :autocomplete_user_name, :on => :collection, as: :autocomplete
    member do
      get 'change_password'
      patch 'update_password'
    end
  end
  post '/departments/select', to: 'departments#select', as: :departments_select
  put '/departments/paste', to: 'departments#paste', as: :departments_paste
  get '/departments/reset', to: 'departments#reset', as: :departments_reset
  resources :roles
  resources :role_members
  resources :rights
  resources :departments do
    get :autocomplete_department_id, :on => :collection, as: :autocomplete
  end
  resources :agreements do
    get :autocomplete_agreement_prop, :on => :collection, as: :autocomplete
  end
  resources :attachments
  resources :attachment_links
  resources :versions, only: [:index]
  resources :agreement_kinds
  resources :organization_kinds
  post "versions/:id/revert" => "versions#revert", as: :revert_version
  get "/attachments/:id/download", to: "attachments#download", as: :attachment_download
  resources :tag_kinds
  resources :tags
  resources :tag_members, only: %i[create destroy]
  resources :incidents do
    get :autocomplete_incident_name, :on => :collection, as: :autocomplete
    collection do
      match 'search' => 'incidents#search', via: [:get, :post], as: :search
    end
  end
  resources :link_kinds
  resources :links, only: %i[create destroy]
  resources :record_templates
  get "/reports/:name", to: 'reports#show', as: :reports
  post "/reports/:name", to: 'reports#show', as: :filtred_reports
  get "/commands/:name", to: 'commands#run', as: :commands
  #mount Blazer::Engine, at: "blazer"
  get "/dashboards/", to: 'dashboards#index', as: :dashboards
  get "/dashboards/:name", to: 'dashboards#show', as: :dashboard
  get "/charts/:name", to: 'charts#show', as: :charts
  resources :hosts do
    get :autocomplete_host_name, :on => :collection, as: :autocomplete
  end
  resources :articles do
    get :autocomplete_article_name, :on => :collection, as: :autocomplete
  end
  get '/serach/index', to: 'search#index', as: :search
  resources :scan_options
  resources :scan_jobs do
    member do
      get 'run'
    end
  end
  resources :scan_results, only: [:index, :show, :search] do
    collection do
      get 'open_ports'
      get 'new_ports'
      match 'search' => 'scan_results#search', via: [:post, :get], as: :search
    end
  end
  resources :host_services
  get '/schedule/', to: 'schedules#show', as: :schedule
  get '/schedules/', to: 'schedules#index', as: :schedules
  post '/schedule/', to: 'schedules#update', as: :update_schedule
  get '/scheduled_jobs/', to: 'scheduled_jobs#index', as: :scheduled_jobs
  delete '/scheduled_jobs/', to: 'scheduled_jobs#destroy', as: :destroy_scheduled_jobs
  resources :scan_jobs_hosts, only: [:index, :create, :destroy]
  resources :scan_job_logs, only: [:index]
  resources :feeds
  resources :investigation_kinds
  resources :investigations do
    member do
      patch :set_readable
      get :enrich
    end
  end
  resources :indicators do
    collection do
      match 'search' => 'indicators#search', via: [:get, :post], as: :search
    end
    member do
      patch :set_readable
      get :enrich
      get :enrichment
      patch :toggle_purpose
      patch :toggle_trust_level
    end
end
  resources :indicator_contexts
  resources :vulnerabilities do
    get :autocomplete_vulnerability_codename, :on => :collection, as: :autocomplete
    collection do
      match 'search' => 'vulnerabilities#search', via: [:get, :post], as: :search
    end
    member do
      patch :toggle_processed
      patch :toggle_custom_relevance
      patch :set_readable
    end
  end
  resources :custom_fields
  resources :delivery_lists
  resources :delivery_subjects do
    collection do
      get 'list_subjects'
    end
    member do
      patch :toggle_processed
    end
  end
  resources :delivery_recipients, only: [:index, :create, :destroy]
  resources :search_filters
  resources :vulnerability_kinds
  resources :vulnerability_bulletin_kinds
  resources :vulnerability_bulletins do
    member do
      patch :set_readable
    end
  end
  resources :vulnerability_bulletin_members, only: %i[index create destroy]

  # resources :schedules, only: [:show]
  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq', constraints: AdminSidekiqWebConstraint.new
  require 'sidekiq/cron/web'
end
