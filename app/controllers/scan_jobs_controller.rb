# frozen_string_literal: true

class ScanJobsController < ApplicationController
  include RecordOfOrganization

  private

  def model
    ScanJob
  end

  def records_includes
    %i[organization scan_option]
  end
end
