# frozen_string_literal: true


class ReportsController < ApplicationController
  def show
    authorize :reports
    report = Reports.report_by_name(params[:name]).new(current_user, params)
    send_data(
      report.file_content,
      type: :docx,
      disposition: 'attachment',
      filename: report.file_name
    )
  end
end
