# frozen_string_literal: true

# Export hosts
# To use run:
# rake rism:export_hosts['hosts.csv']

namespace :rism do
  desc 'Export hosts services to CSV file'
  task(
    :export_hosts,
    [:hosts_file] => [:environment]
  ) do |_task, args|
    CSV.open(
      args[:hosts_file],
      'wb',
      col_sep: ';',
    ) do |line|
      Host.all.each do |record|
        row = []
        row << record.organization.name
        row << record.ip
        row << record.name
        row << record.description
        line << row
      end
    end
  end
end
