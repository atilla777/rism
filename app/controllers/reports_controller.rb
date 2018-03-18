# frozen_string_literal: true

require 'organization_incidents'

class ReportsController < ApplicationController
  def show
    authorize :reports
    report = Reports::OrganizationIncidents.new
    send_data(
      report.file,
      type: :docx,
      disposition: 'attachment',
      filename: report.file_name
    )
  end
end
