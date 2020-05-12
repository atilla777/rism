# frozen_string_literal: true

# Trim database (delete old records, like action logs etc.)
class DatabaseTrimJob < ApplicationJob

  SESSION_CUTOFF_DAYS = 5
  USER_ACTION_CUTOFF_MONTH = 6

  queue_as do
    self.arguments&.first || :default
  end

  def perform(_)
    trim_sessions
    trim_user_actions
    log
  end

  private

  def trim_sessions
    cutoff_period = SESSION_CUTOFF_DAYS.days.ago
    ActiveRecord::SessionStore::Session.
      where("updated_at < ?", cutoff_period).
      delete_all
  end

  def trim_user_actions
    cutoff_period = USER_ACTION_CUTOFF_MONTH.month.ago
    UserAction.where("created_at < ?", cutoff_period).
      delete_all
  end

  def log
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_info.log'))
    logger.tagged("SESSIONS_TRIM (#{Time.now}):") do
      logger.info("Sessions table was trimmed.")
    end
  end
end
