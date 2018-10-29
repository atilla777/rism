# frozen_string_literal: true

namespace :rism do
  desc 'Set scan_engine from scan_jobs to scan_results'
  task set_scan_engine: [:environment] do |_task, args|
    current_user = User.find(1)
    ScanResult.all.includes(:scan_job).each do |scan_result|
      begin
        scan_result.scan_engine = scan_result.scan_job.scan_engine
        scan_result.current_user = current_user
        scan_result.save
      rescue => e
        pp "Error set scan_engine for scan result id=#{scan_result.id} - #{e}"
      end
    end
  end
end
