# frozen_string_literal: true

# Export hosts services
# To use run:
# rake rism:export_hosts_services['services.csv']

namespace :rism do
  desc 'Export hosts services to CSV file'
  task(
    :export_hosts_services,
    [:hosts_services_file] => [:environment]
  ) do |_task, args|
    CSV.open(
      args[:hosts_services_file],
      'wb',
      col_sep: ';',
    ) do |line|
      HostService.all.each do |record|
        row = []
        row << record.host.ip
        row << record.organization.name
        row << record.name
        row << record.port
        row << record.protocol
        row << record.legality
        row << record.vulnerable
        row << record.vuln_description
        row << record.description
        line << row
      end
    end
  end
end
