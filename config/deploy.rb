# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

set :application, "rism"
set :repo_url, "https://github.com/atilla777/rism.git"
set :puma_init_active_record, true
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, "/home/rism/prod"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true
set :pty,  false

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set(
  :linked_dirs,
  fetch(:linked_dirs, []).push(
    'log',
    'tmp/pids',
    'tmp/cache',
    'tmp/sockets',
    'tmp/nmap',
    'tmp/vulners',
    'vendor/bundle',
    'public/system',
    'file_storage'
  )
)
set(
  :linked_files,
  fetch(:linked_files, []).push(
    '.env.production',
    'puma.service',
    'sidekiq.service',
    'config/sidekiq.yml',
    'config/environments/production.rb',
    'config/schedule.yml'
  )
)

# to use with proxy with spoofed certificate
# set :bundle_env_variables, {'BUNDLE_SSL_VERIFY_MODE'=>'0'}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }
# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
