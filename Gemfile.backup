source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'data-confirm-modal'

group :development, :test do
  gem 'rspec-rails', '~> 3.6'
  gem 'factory_bot_rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'meta_request'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Chrome rails panel plugin
  gem 'web-console', '>= 3.3.0'
  gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'authlogic', '~> 3.6.1'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bootswatch-rails'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'kaminari'
gem 'pundit'
gem 'ransack'
gem 'slim-rails'
gem 'jquery-ui-rails'
gem 'rails-jquery-autocomplete'
gem 'paper_trail'
gem 'carrierwave', '~> 1.0'
gem 'dotenv-rails'
gem 'caracal'
#gem 'blazer'
gem "chartkick"
gem 'groupdate'
gem 'hightop'

# Lint with overcommit
group :development do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'overcommit', require: false
  gem 'rails_best_practices', require: false
  gem 'reek', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'capistrano', '~> 3.6', require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma', require: false
  #gem 'capistrano-nginx', require: false
  gem 'capistrano-rails-collection', require: false
  # gem 'capistrano-sidekiq', require: false
end

group :test do
  gem 'shoulda-matchers', '~> 2.0'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'launchy'
end
