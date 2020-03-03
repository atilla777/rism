# frozen_string_literai: true

class CustomReportJob < ApplicationJob
  queue_as do
    self.arguments.first.to_sym
  end

  def perform(_queue, custom_reports_result_id )
   @custom_reports_result = CustomReportsResult.find(custom_reports_result_id)
   custom_report = @custom_reports_result.custom_report
   save_result CustomReportJob::Query.new(
     custom_report.statement,
     @custom_reports_result.variables
   ).run
  end

  private

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
