require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rism
  class Application < Rails::Application
    require 'letter_opener' if Rails.env.development?
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.action_view.field_error_proc = Proc.new { |html_tag, instance|
        "<div class='text-danger has-error' >#{html_tag}</div>".html_safe
      }
    config.i18n.default_locale = :ru
    config.time_zone = 'Moscow'
    config.assets.precompile += %w( ckeditor/* )

    config.active_job.queue_adapter = :sidekiq

    config.active_record.schema_format = :sql

    config.autoload_paths << "#{Rails.root}/lib"

    config.eager_load_paths << "#{Rails.root}/lib"

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
