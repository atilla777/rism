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
    if job.scan_engine == 'nmap'
      NetScan::NmapScan.new(job).run
    else
      NetScan::ShodanScan.new(job).run
    end
  end
end
