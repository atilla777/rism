# frozen_string_literal: true

# Import hosts and creat organizations that hosts belongs
# Use it it to import data to empty RISM database
# To use run:
# rake rism:import_hosts['hosts.csv','ООО МММ','дочерние','стоп']
# Where:
# ООО МММ - parent organization name for all created organizations
# stop - word that will be deleted from host organizations names
# to create organizations codenames (when organizatoins will be created)

# Imported file format:
# host organization name; host ip; host name; host description

namespace :rism do
  desc 'Import hosts from CSV file - organization, ip, description1, descriptionN'
  task(
    :import_hosts,
    [:hosts_file, :parent, :organization_kind, :stop_word] => [:environment]
  ) do |_task, args|

    current_user = User.where(id: 1).first

    codename = args[:parent].gsub(
        /[^[:alpha:]]|ООО|АО|ПАО|#{args[:stop_word]}|\s/,
        ''
    ).truncate(15, omission: '')
#{SecureRandom.uuid}
   codename += " CODENAME" if codename.length < 3
    parent_organization = Organization.find_or_create_by!(
      name: args[:parent].strip
    ) do |org|
        org.current_user = current_user
        org.codename = codename
    end

    organization_kind = OrganizationKind.find_or_create_by!(
      name: args[:organization_kind].strip
    )

    CSV.foreach(
      args[:hosts_file],
      col_sep: ';',
      headers: %i[organization_name ip name description]
    ) do |row|
      attributes = row.to_h
      begin
        organization = Organization.find_or_create_by!(
          name: attributes[:organization_name]
        ) do |org|
          org.organization_kind_id = organization_kind.id
          org.parent_id = parent_organization.id
          org.current_user = current_user
          codename = attributes[:organization_name].gsub(
              /[^[:alpha:]]|ООО|АО|ПАО|#{args[:stop_word]}|\s/,
              ''
          ).truncate(15, omission: '')
          codename += ' CODENAME' if codename.length < 3
          org.codename = codename
        end
        Host.create!(
          name: attributes[:name],
          organization_id: organization.id,
          ip: attributes[:ip].strip,
          description: attributes[:description],
          current_user: current_user
        )
      rescue => e
        pp "Import error - #{e}: #{attributes}"
      end
    end
  end
end
