# frozen_string_literal: true

# config NvdBaseSync job start preiod
schedule_file = "config/schedule.yml".freeze

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
