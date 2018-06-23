class NetScanJob < ApplicationJob

  queue_as do
    arg = self.arguments.second
    if arg == 'now'
      :now_scan
    else
      :scheduled_scan
    end
      :default
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
