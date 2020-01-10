# frozen_string_literal: true

# Import hosts services
# Use it when host already imported
# To use run:
# rake rism:import_hosts_services['services.csv','stop']
# Imported file format - see "headers" in code below
# Where:
# stop - word that will be deleted from host service organizations names
# to create organizations codenames (when organizatoins will be created)

namespace :rism do
  desc 'Import hosts services from CSV file'
  task(
    :import_hosts_services,
    [:hosts_services_file, :stop_word] => [:environment]
  ) do |_task, args|

    current_user = User.where(id: 1).first

    headers = %i[
      host_ip
      organization_name
      name
      port
      protocol
      legality
      vulnerable
      vuln_description
      description
    ]

    CSV.foreach(
      args[:hosts_services_file],
      col_sep: ';',
      headers: headers
    ) do |row|
      attributes = row.to_h

      host = Host.where(ip: attributes[:host_ip]).first

      begin
        organization = Organization.find_or_create_by!(
          name: attributes[:organization_name]
        ) do |org|
          org.current_user = current_user
          codename = attributes[:organization_name].gsub(
            /[^[:alpha:]]|ООО|АО|ПАО|#{args[:stop_word]}|\s/,
            ''
          ).truncate(15, omission: '')
          codename += ' CODENAME' if codename.length < 3
          org.codename = codename
        end

        HostService.create!(
          host_id: host.id,
          organization_id: organization.id,
          name: attributes[:name],
          port: attributes[:port],
          protocol: attributes[:protocol],
          legality: attributes[:legality].to_sym,
          vulnerable: attributes[:vulnerable],
          vuln_description: attributes[:vuln_description],
          current_user: current_user,
          description: attributes[:description]
        )
      rescue => e
        pp "Import error - #{e}: #{attributes}"
      end
    end
  end
end
