Rails.application.routes.draw do
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
      patch 'generate_api_token'
    end
  end

  post '/departments/select', to: 'departments#select', as: :departments_select
  put '/departments/paste', to: 'departments#paste', as: :departments_paste
  get '/departments/reset', to: 'departments#reset', as: :departments_reset

  resources :roles do
    get :autocomplete_role_name, :on => :collection, as: :autocomplete
  end

  resources :role_members
  patch(
    '/role_members',
    to: 'role_members#clone',
    as: :clone_roles
  )

  resources :rights
  resources :departments do
    get :autocomplete_department_id, :on => :collection, as: :autocomplete
  end
  resources :agreements do
    get :autocomplete_agreement_prop, :on => :collection, as: :autocomplete
  end

  post '/uploads', to: 'attached_files#create', as: :uploads # For upload images via CKEditor
  resources :attached_files, only: [:create, :show, :destroy] # For attach/download/delete files in record by user
  # Show image in article
  get(
    'articles/:id/files/:file_name',
    to: 'attached_files#download_image',
    as: :article_download_file,
    constraints: { file_name: /[^\/]*/ }
  )

  resources :versions, only: [:index]
  resources :agreement_kinds
  resources :organization_kinds
  post "versions/:id/revert" => "versions#revert", as: :revert_version
  get "/attachments/:id/download", to: "attachments#download", as: :attachment_download
  resources :tag_kinds
  resources :tags
  resources :tag_members, only: %i[create destroy]
  resources :incidents do
    get :autocomplete_inciden_name, :on => :collection, as: :autocomplete
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
  get "/investigations_dashboard/", to: 'dashboards#investigations_dashboard', as: :investigations_dashboard
  get "/vulnerabilities_dashboard/", to: 'dashboards#vulnerabilities_dashboard', as: :vulnerabilities_dashboard
  get "/user_actions_dashboard/", to: 'dashboards#user_actions_dashboard', as: :user_actions_dashboard
  get "/dashboards/:name", to: 'dashboards#show', as: :dashboard
  get "/charts/:name", to: 'charts#show', as: :charts
  resources :hosts do
    get :autocomplete_host_name, :on => :collection, as: :autocomplete
    member do
      patch :toggle_readable
    end
    collection do
      match 'search' => 'hosts#search', via: [:get, :post], as: :search
      get :new_import
      post :create_import
    end
  end

  resources :articles do
    get :autocomplete_article_name, :on => :collection, as: :autocomplete
    collection do
      patch :toggle_subscription
    end
    member do
      patch :publicate
    end
  end

  resources :articles_folders
  post(
    '/articles_folders_select',
    to: 'articles_folders#select',
    as: :articles_folders_select
  )
  put(
    '/articles_folders_paste',
    to: 'articles_folders#paste',
    as: :articles_folders_paste
  )
  get(
    '/articles_folders_reset',
    to: 'articles_folders#reset',
    as: :articles_folders_reset
  )

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
  resources :host_service_statuses
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
    collection do
      match 'search' => 'investigations#search', via: [:get, :post], as: :search
      patch :toggle_subscription
    end
    member do
      patch :toggle_readable
      patch :publicate
      post :clone
    end
  end
  resources :indicators do
    collection do
      match 'search' => 'indicators#search', via: [:get, :post], as: :search
      get :tree_show
      post :select
      put :paste
      get :reset
    end
    member do
      patch :toggle_readable
      patch :toggle_purpose
      patch :toggle_trust_level
    end
  end
  resources :enrichments, only: [:index, :show, :create, :destroy]
  resources :indicator_contexts
  resources :vulnerabilities do
    get :autocomplete_vulnerability_codename, :on => :collection, as: :autocomplete
    collection do
      match 'search' => 'vulnerabilities#search', via: [:get, :post], as: :search
      get :new_import
      post :create_import
    end
    member do
      patch :toggle_processed
      patch :toggle_custom_relevance
      patch :toggle_readable
    end
  end
  resources :custom_fields
  resources :delivery_lists
  resources :delivery_subjects, only: [:index, :create, :destroy] do
    collection do
      get 'list_subjects'
      post 'notify' => 'delivery_subjects#notify', via: [:get], as: :notify
    end
    member do
      patch :toggle_readable
    end
  end
  resources :delivery_recipients, only: [:index, :create, :destroy]
  resources :search_filters
  resources :vulnerability_kinds
  resources :vulnerability_bulletin_kinds
  resources :vulnerability_bulletins do
    collection do
      patch :toggle_subscription
    end
    member do
      patch :toggle_readable
      patch :publicate
    end
  end
  resources :vulnerability_bulletin_members, only: %i[index create destroy]
  resources :vulnerability_bulletin_statuses

  resources :user_actions, only: [:index, :show]

  post '/translatet', to: 'translate#show', as: :translate

  resources :notifications_logs, only: [:index]

  resources :selectors, only: [:index]

  patch(
    '/selectors',
    to: 'selectors#update',
    as: :toggle_selection
  )
  delete(
    '/reset_selections',
    to: 'selectors#destroy',
    as: :reset_selections
  )

  patch(
    '/toggle_processed_processing_logs',
    to: 'processing_logs#toggle_processed',
    as: :toggle_processed_processing_logs
  )

  resources :custom_reports
  resources :custom_reports_folders do
    collection do
      post :paste
    end
  end

  resources :custom_reports_results, only: [:index, :show, :new, :create, :destroy, :download] do
    member do
      get 'download'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :custom_reports_api, only: [:show]
      resources :ra_api, only: [:create]
    end
  end

  resources :agents

  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq', constraints: AdminSidekiqWebConstraint.new
  require 'sidekiq/cron/web'

  # TODO: use or delete (it for routing error handling when api client used)
  # match '*path', to: "api/v1/routing_error#show", format: true, constraints: {format: :json}, defaults: {format: 'html'}, via: [:get, :post]
end
