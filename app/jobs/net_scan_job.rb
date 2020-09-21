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
    if job.agent.present?
      NetScan::AgentScan.new(job, jid).run
    else
      if job.scan_engine == 'nmap'
        NetScan::NmapScan.new(job, jid).run
      else
        NetScan::ShodanScan.new(job, jid).run
      end
      ScanJobLog.log(:finish, job.id, jid, args[1] )
    end
  end
end
