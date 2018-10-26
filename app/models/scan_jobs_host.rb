class ScanJobsHost < ApplicationRecord
  validates :scan_job_id, numericality: { only_integer: true }
  validates :host_id, numericality: { only_integer: true}

  belongs_to :scan_job
  belongs_to :host
end
