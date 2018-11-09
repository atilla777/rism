# frozen_string_literal: true

class ReportsController < ApplicationController
  def show
    authorize :reports
    report = Reports.report_by_name(params[:name])
      .new(current_user, params[:format].to_sym, params)
    send_data(
      report.rendered_file.encode('Windows-1251'),
      type: params[:format].to_sym,
      disposition: 'attachment',
      filename: report.file_name
    )
  end
end
