# frozen_string_literal: true

# Config to allow redis to work on separate server
host = ENV['REDIS_HOST'] || '127.0.0.1'
port = ENV['REDIS_PORT'] || '6379'
database = ENV['REDIS_DB'] || 0
url = "redis://#{host}:#{port}/#{database}"
config_redis = {host: host, port: port, url: url}
Sidekiq.configure_server { |config| config.redis = config_redis }
Sidekiq.configure_client { |config| config.redis = config_redis }

# config NvdBaseSync job start preiod
schedule_file = "config/schedule.yml".freeze

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
