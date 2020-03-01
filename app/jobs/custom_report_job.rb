# frozen_string_literai: true

class CustomReportJob < ApplicationJob
  queue_as do
    self.arguments.first.to_sym
  end

  def perform(_queue, custom_reports_result_id )
   @custom_reports_result = CustomReportsResult.find(custom_reports_result_id)
   custom_report = @custom_reports_result.custom_report
   #bindings = [[nil, 100]]
   # new = ActiveRecord::Base.connection.exec_query(sql, 'SQL', bindings).first
   @result = ActiveRecord::Base.connection.exec_query(custom_report.statement).first
   save_result
  end

  private

  def save_result
    @custom_reports_result.result_path = @result
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
          #{@report.errors.full_messages},
          custom_report
          ID
          -
          #{@report.id}).join(' ')
      )
    end
  end
end
