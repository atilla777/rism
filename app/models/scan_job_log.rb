class ScanJobLog < ApplicationRecord
  include ScanJobLog::Ransackers

  validates :scan_job_id, uniqueness: { scope: :jid}
  validates :scan_job_id, numericality: { only_integer: true }
  validates :start, presence: true
  validates :jid, presence: true
  validates :queue, presence: true

  belongs_to :scan_job

  def working?
    Sidekiq::Workers.new.any?{|_,_, work| work['payload']['jid'] == jid}
  end
end
