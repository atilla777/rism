class NetScanJob < ApplicationJob

  queue_as do
    arg = self.arguments.second
    if arg == 'now'
      :now_scan
    elsif arg == 'scheduled'
      :scheduled_scan
    elsif arg == 'free_shodan'
      :free_shodan_scan
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
