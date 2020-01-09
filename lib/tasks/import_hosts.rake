# frozen_string_literal: true

# Imported file format:
# host organization name; host ip; host name; host description

namespace :rism do
  desc 'Import hosts from CSV file - organization, ip, description1, descriptionN'
  task(
    :import_hosts,
    [:hosts_file, :parent, :organization_kind] => [:environment]
  ) do |_task, args|
    CSV.foreach(
      args[:hosts_file],
      encoding:'windows-1251:utf-8',
      col_sep: ';',
      headers: %i[organization_name ip name description]
    ) do |row|

    end


    File.open(args[:hosts_file], 'r') do |file|
      current_user = User.where(id: 1).first
      parent = Organization.find_or_create_by(name: args[:parent]) do |o|
        o.current_user = current_user
      end
      organization_kind = OrganizationKind.find_or_create_by(name: args[:organization_kind].strip)
      file.readlines.each do |line|
        attributes = line.split(';')
          begin
            raise ArgumentError if attributes.size < 2
            organization = Organization.find_or_create_by!(name: attributes[0].strip) do |o|
              o.organization_kind_id = organization_kind.id
              o.parent_id = parent.id
              o.current_user = current_user
            end
            description = ''
            (2...attributes.size).each do |i|
              description += "#{attributes[i]}\n"
            end
            Host.create!(
              name: '',
              organization_id: organization.id,
              ip: attributes[1].strip,
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
