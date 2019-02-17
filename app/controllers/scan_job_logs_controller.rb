# frozen_string_literal: true

class ScanJobLogsController < ApplicationController
  include RecordOfOrganization

  def index
    authorize model
    if params[:job_id].present? || params.dig(:q, :job_id_eq)
      index_for_scan_job
    else
      index_for_all_jobs
    end
  end

  def index_for_all_jobs
    @records = records(model)
    render 'index_for_all_jobs'
  end

  def index_for_scan_job
    scan_job_id = if params[:job_id]
                params[:job_id]
              else
                params[:q][:job_id_eq]
              end
    @records = records(model.where(scan_job_id: scan_job_id))
    @job = ScanJob.find(scan_job_id)
  end

  private

  def model
    ScanJobLog
  end

  def default_sort
    ['status desc', 'start desc']
  end

  def records_includes
    %i[scan_job]
  end
end
