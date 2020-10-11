# frozen_string_literal: true

# config NvdBaseSync job start preiod
schedule_file = "config/schedule.yml".freeze

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq.configure_server do |config|
  config.redis = {
    host: ENV['REDIS_HOST'] || '127.0.0.1',
    port: ENV['REDIS_PORT'] || '6379'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    host: ENV['REDIS_HOST'] || '127.0.0.1',
    port: ENV['REDIS_PORT'] || '6379'
  }
end
