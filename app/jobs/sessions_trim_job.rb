# frozen_string_literal: true

class SessionsTrimJob < ApplicationJob

  queue_as do
    self.arguments&.first || :default
  end

  def perform(_)
    trim
    log
  end

  private

  def trim
    #cutoff_period = (ENV['SESSION_DAYS_TRIM_THRESHOLD'] || 30).to_i.days.ago
    cutoff_period = (5).to_i.days.ago
    ActiveRecord::SessionStore::Session.
      where("updated_at < ?", cutoff_period).
      delete_all
  end

  def log
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_info.log'))
    logger.tagged("SESSIONS_TRIM:") do
      logger.info("Sessions table was trimmed.")
    end
  end
end
