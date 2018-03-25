# frozen_string_literal: true

#require_dependency 'reports'

# = Report button helper
# Make links to allowed for record or records reports
#
# It assumes that bootstrap and slim is used in the Rails project.
module ReportButtonHelper
  def report_button_for(record_or_records, options = {})
    options = options.select { |key, value| value }
    report_model = case record_or_records
              when ActiveRecord::Relation
                record_or_records.klass
                                 .model_name
              when ActiveRecord::Base
                record_or_records.class
                                 .model_name
              else
                raise(
                  ArgumentError,
                  'It should be a one record or several records.'
                )
              end
    reports = Reports.names_where(
      report_model: report_model,
      params: options
    )
    return if reports.blank?
    render(
      'helpers/report_button',
      reports: reports,
      options: options
    )
  end
end
