source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1.4'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.1'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'data-confirm-modal', "~> 1.6"

group :development, :test do
  gem 'rspec-rails', '~> 3.7'
  gem 'factory_bot_rails', "~> 4.8"
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', "~> 10.0", platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.18'
  gem 'selenium-webdriver', "~> 3.11"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.1', '< 3.2'
  gem 'meta_request', "~> 0.5"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', "~> 2.0"
  gem 'spring-watcher-listen', '~> 2.0'
  # Chrome rails panel plugin
  gem 'web-console', '~> 3.5'
  gem 'bullet', "~> 5.7"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'authlogic', '~> 3.6'
gem 'bootstrap-sass', '~> 3.4'
gem 'bootswatch-rails', "~> 3.3"
gem 'font-awesome-rails', "~> 4.7"
gem 'jquery-rails', "~> 4.3"
gem 'kaminari', "~> 1.1"
gem 'pundit', "~> 1.1"
gem 'ransack', "~> 1.8"
gem 'slim-rails', "~> 3.1"
gem 'jquery-ui-rails', "~> 6.0"
gem 'rails-jquery-autocomplete', "~> 1.0"
gem 'paper_trail', "~> 8.1"
gem 'dotenv-rails', "~> 2.2"
gem 'caracal', "~> 1.4"
gem "chartkick", "~> 3.2" # 2.3
gem 'groupdate', "~> 4.0"
gem 'hightop', "~> 0.2"
gem 'pg_search', '~> 2.1'
gem 'sidekiq', '~> 5.1.3'
gem 'rufus-scheduler', '3.4.2' # TODO: check that newer versions API (> 3.4.2) was fixed and work
gem 'sidekiq-cron', '~> 0.6.3 '
gem 'ruby-nmap', '~> 0.9.3'
gem 'httparty', '~> 0.16.2'
gem 'sidekiq-limit_fetch', '~> 3.4.0'
gem 'oj', '~> 3.7.12'
gem 'rails_autolink', '~> 1.1.6'
gem 'activerecord-session_store', '~> 1.1.3'
gem 'hashie', '~> 4.0.0'
gem 'activerecord-import', '~> 1.0'
gem 'webpacker', '~> 4.x'

# Lint with overcommit
group :development do
  gem 'brakeman', "~> 4.2", require: false
  gem 'bundler-audit', "~> 0.6", require: false
  gem 'overcommit', "~> 0.44", require: false
  gem 'rails_best_practices', "~> 1.19", require: false
  gem 'reek', "~> 4.8", require: false
  gem 'rubocop', "~> 0.54", require: false
  gem 'rubocop-rspec', "~> 1.24", require: false
  gem 'capistrano', '~> 3.10', require: false
  gem 'capistrano-rails', '~> 1.3', require: false
  gem 'capistrano-locally', '~> 0.2', require: false
  gem 'capistrano-rvm', "~> 0.1", require: false
  gem 'capistrano-bundler', "~> 1.3", require: false
  gem 'capistrano3-puma', "~> 3.1", require: false
  #gem 'capistrano-nginx', require: false
  gem 'capistrano-rails-collection', "~> 0.1", require: false
  gem 'capistrano-sidekiq', require: false
  gem "letter_opener", "~> 1.7", require: false
  gem 'rails-erd', "~> 1.6", require: false
  gem 'railroady', "~> 1.5", require: false
end

group :test do
  gem 'shoulda-matchers', '~> 2.8'
  gem 'database_cleaner', "~> 1.6"
  gem 'rails-controller-testing', "~> 1.0"
  gem 'launchy', "~> 2.4"
end
