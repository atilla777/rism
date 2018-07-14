# frozen_string_literal: true

class ScanJobsController < ApplicationController
  include RecordOfOrganization

  def run
    @record = record
    authorize @record
    active_job = NetScanJob.perform_later(
      @record.id,
      @record.job_queue('now_scan')
    )
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

  def preset_record
    return if params.blank?
    @record.hosts = params[:ip] if params[:ip].present?
    if params[:host_id].present?
      @record.hosts = Host.find(params[:host_id]).ip
    end
    @record.ports = params[:port_number] if params[:port_number].present?
    if params[:service].present?
      name = [params[:service]]
      name << @organization.name if @organization.present?
      @record.name = name.join(' ')
    end
  end
end
