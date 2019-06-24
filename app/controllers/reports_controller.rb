# frozen_string_literal: true

class ReportsController < ApplicationController
  def show
    authorize :reports
    report = Reports.report_by_name(params[:name])
      .new(current_user, params[:format].to_sym, params)
    file = if params[:format] == 'csv'
      report.rendered_file.encode('Windows-1251', invalid: :replace, undef: :replace)
    else
      report.rendered_file
    end
    send_data(
      file,
      type: params[:format].to_sym,
      disposition: 'attachment',
      filename: report.file_name
    )
  end
end
