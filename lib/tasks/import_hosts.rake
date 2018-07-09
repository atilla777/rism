# frozen_string_literal: true

namespace :rism do
  desc 'Import hosts from CSV file - organization, ip, description1, descriptionN'
  task :import_hosts , [:hosts_file, :parent, :kind] => [:environment] do |_task, args|
    File.open(args[:hosts_file], 'r') do |file|
      current_user = User.where(id: 1)
      parent = Organization.find_or_create_by(name: args[:parent]) do |o|
        o.current_user = current_user
      end
      kind = OrganizationKind.find_or_create_by(name: args[:kind])
      file.readlines.each do |line|
        attributes = line.split(',')
          begin
            organization = Organization.find_or_create_by!(name: attributes[0]) do |o|
              o.parent = parent.id,
              o.organization_kind_id = kind.id,
              o.current_user = current_user
            end
            description = ''
            (0..attributes.size - 2).each do |i|
              description += "{attributes[1 + i]}\n"
            end
            Host.create!(
              organization_id: organization.id,
              ip: attributes[1],
              description: description,
              current_user: current_user
            )
          rescue => e
            pp "Import error #{line} - #{e}"
          end
      end
    end
  end
end
