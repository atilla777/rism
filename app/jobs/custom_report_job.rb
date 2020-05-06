# frozen_string_literai: true

class CustomReportJob < ApplicationJob
  queue_as do
    self.arguments.second.to_sym
  end

  def perform(custom_report_id, _queue, custom_reports_result_id = nil)
    @custom_reports_result = if custom_reports_result_id
      CustomReportsResult.find(custom_reports_result_id)
    else
      CustomReportsResult.create(
        custom_report_id: custom_report_id,
        skip_current_user_check: true
      )
    end
   @custom_report = @custom_reports_result.custom_report
   save_result CustomReportJob::Query.new(
     @custom_report.statement,
     @custom_reports_result.variables
   ).run
  rescue ActiveRecord::RecordNotFound => error
    log_error(@custom_report.id, error)
  rescue StandardError => error
    log_error(@custom_report.id, error)
  end

  private

  def log_error(custom_report_id, error)
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
    logger.tagged("CUSTOM_REPORT (#{Time.now}): ") do
      logger.error(
        %W(
          custom
          report
          result
          can`t
          be
          create
          -
          #{error},
          custom report ID
          -
          #{custom_report_id}).join(' ')
      )
    end
  end

  def save_result(result)
    @custom_reports_result.result_path = CustomReportJob::ReportFile.new(
      result,
      @custom_reports_result
    ).save
    @custom_reports_result.skip_current_user_check = true
    @custom_reports_result.save!
  rescue ActiveRecord::RecordInvalid
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
    logger.tagged("CUSTOM_REPORT (#{Time.now}): ") do
      logger.error(
        %W(
          custom_report
          path
          can`t
          be
          saved
          -
          #{@custom_reports_result.errors.full_messages},
          custom_report
          ID
          -
          #{@custom_reports_result.id}).join(' ')
      )
    end
  end
end
