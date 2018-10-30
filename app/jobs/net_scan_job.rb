class NetScanJob < ApplicationJob
  Sidekiq.default_worker_options = { 'retry' => 2 }

  queue_as do
    arg = self.arguments.second
    if arg.present?
      arg.to_sym
    else
      :default
    end
  end

  def perform(*args)
    job = ScanJob.find(args[0])
    log_scan_job(:start, job.id, jid, args[1])
    if job.scan_engine == 'nmap'
      NetScan::NmapScan.new(job).run
    else
      NetScan::ShodanScan.new(job).run
    end
    log_scan_job(:finish, job.id, jid, args[1] )
  end

  private

  def log_scan_job(point, scan_job_id, jid, queue)
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
end
