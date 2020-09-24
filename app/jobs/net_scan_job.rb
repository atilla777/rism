class NetScanJob < ApplicationJob
  Sidekiq.default_worker_options = {'retry' => 2}

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
    if job.agent.present?
      ScanJobLog.log(:start, job.id, jid, args[1], job.agent.id)
      NetScan::AgentScan.new(job, jid).run
    else
      ScanJobLog.log(:start, job.id, jid, args[1])
      if job.scan_engine == 'nmap'
        NetScan::NmapScan.new(job, jid).run
      else
        NetScan::ShodanScan.new(job, jid).run
      end
      ScanJobLog.log(:finish, job.id, jid)
    end
  end
end
