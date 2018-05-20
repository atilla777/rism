# frozen_string_literal: true

class ScanResultsController < ApplicationController
  include RecordOfOrganization

  def index
    authorize model
    @organization = organization
    if @organization.id
      @records = records(filter_for_organization)
      render 'organization_index'
    else
      @records = records(model)
    end
  end

  private

  def model
    ScanResult
  end

  def default_sort
    'finished desc'
  end

  def records_includes
    %i[organization scan_job]
  end

  def filter_for_organization
    model.joins('JOIN hosts ON scan_results.ip <<= hosts.ip')
         .where('hosts.organization_id = ?', @organization.id)
  end
end
