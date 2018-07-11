# frozen_string_literal: true

namespace :rism do
  desc 'Import hosts from CSV file - organization, ip, description1, descriptionN'
  task add_scan_jobs: [:environment] do |_task, args|
    current_user = User.find(1)
    scan_option1 = ScanOption.find_or_create_by(name: 'Default1')
    scan_option2 = ScanOption.find_or_create_by(name: 'Default2')
    Organization.all.each do |organization|
      ip_list = organization.hosts.pluck(:ip)
      next if ip_list.blank?
      params ={
        organization_id: organization.id,
        current_user: current_user,
        hosts: ip_list.join(',')
      }
      begin
        ScanJob.create!(
          params.merge(
            scan_engine: 'nmap',
            scan_option_id: scan_option1.id,
            name: "#{organization.name} nmap"
          )
        )
        ScanJob.create!(
          params.merge(
            scan_engine: 'shodan',
            scan_option_id: scan_option2.id,
            name: "#{organization.name} shodan"
          )
        )
      rescue => e
        pp "Error job creation for #{organization.name} - #{e}"
      end
    end
  end
end
