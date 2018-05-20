# frozen_string_literal: true

class ScanResultsController < ApplicationController
  include RecordOfOrganization

  def index
    authorize model
    @organization = organization
    if @organization.id
      @records = records(filter_for_organization)
    else
      @records = records(model)
    end
  end

  private

  def model
    ScanResult
  end

  def records_includes
    %i[organization scan_job]
  end
end
