# frozen_string_literal: true

# Trim database (delete old records, like action logs etc.)
class DatabaseTrimJob < ApplicationJob

  SESSION_CUTOFF_DAYS = ENV['SESSION_CUTOFF_DAYS']&.to_i || 5
  USER_ACTION_CUTOFF_MONTH = ENV['USER_ACTION_CUTOFF_MONTH']&.to_i
  INVESTIGATION_CUTOFF_MONTH = ENV['INVESTIGATION_CUTOFF_MONTH']&.to_i
  SCAN_RESULT_CUTOFF_MONTH = ENV['SCAN_RESULT_CUTOFF_MONTH']&.to_i

  queue_as do
    self.arguments&.first || :default
  end

  def perform(_)
    trim_sessions
    trim_user_actions
    trim_investigations
    trim_scan_results
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
    return unless USER_ACTION_CUTOFF_MONTH
    cutoff_period = USER_ACTION_CUTOFF_MONTH.month.ago
    UserAction.where("created_at < ?", cutoff_period).
      delete_all
  end

  def trim_investigations
    return unless INVESTIGATION_CUTOFF_MONTH
    cutoff_period = INVESTIGATION_CUTOFF_MONTH.month.ago
    Investigation.where("created_at < ?", cutoff_period).
      destroy_all
  end

  def trim_scan_results
    return unless SCAN_RESULT_CUTOFF_MONTH
    cutoff_period = SCAN_RESULT_CUTOFF_MONTH.month.ago
    ScanResult.where("created_at < ?", cutoff_period).
      delete_all
    ScanJobLog.where("created_at < ?", cutoff_period).
      delete_all
  end

  def log
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_info.log'))
    logger.tagged("DATABASE_TRIM (#{Time.now}):") do
      logger.info("Session, user action and investigation tables was trimmed.")
    end
  end
end
