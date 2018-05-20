# frozen_string_literal: true

class ScanJobsController < ApplicationController
  include RecordOfOrganization

  def run
    @record = record
    authorize @record
    active_job = NetScanJob.perform_later(@record, 'now')
    #protocol_action("scan started by #{@job.name}")
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization&.id,
      success: t('flashes.now_scan', net_scan_job_id: active_job.provider_job_id)
    )
  end

  private

  def model
    ScanJob
  end

  def records_includes
    %i[organization scan_option]
  end
end
