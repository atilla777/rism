# frozen_string_literal: true

class ScanJobLog < ApplicationRecord
  include ScanJobLog::Ransackers

  validates :scan_job_id, uniqueness: { scope: :jid}
  validates :scan_job_id, numericality: { only_integer: true }
  validates :start, presence: true
  validates :jid, presence: true
  validates :queue, presence: true

  belongs_to :scan_job

  def self.log(point, scan_job_id, jid, queue)
    attributes = {
      scan_job_id: scan_job_id,
      jid: jid,
      queue: queue
    }
    if point == :start
      situable_date = { start: DateTime.now }
    else
      situable_date = { finish: DateTime.now }
    end
    scan_job_log = ScanJobLog.find_or_initialize_by(scan_job_id: scan_job_id, jid: jid)
    scan_job_log.attributes = attributes.merge(situable_date)
    scan_job_log.save!
  end

  def working?
    Sidekiq::Workers.new.any?{|_,_, work| work['payload']['jid'] == jid}
  end
end
