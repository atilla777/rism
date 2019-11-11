# frozen_string_literal: true

# Refill vulnerabilities products names and vendors
# To use run:
# rake rism:refill_vulnerabilities_products_from['09.09.2019']

namespace :rism do
  desc 'Refill vulnerabilities products names and vendors.'
  task :refill_vulnerabilities_products_from, [:date] => [:environment] do |_task, args|
    refill_from_date args[:date]
  end
end

def refill_from_date(date)
  Vulnerability.where("updated_at > ?", date.to_datetime)
               .pluck(:id)
               .each do |id|
    set_products_info(Vulnerability.find(id))
  end
end

def set_products_info(vulnerability)
  return if vulnerability.raw_data == '{}'
  return if vulnerability.raw_data.dig('configurations', 'nodes').blank?
  vendors = NvdBase::Parser.vendors(vulnerability.raw_data)
  products = NvdBase::Parser.products(vulnerability.raw_data)
  vulnerability.vendors = vendors
  vulnerability.products = products
  begin
    vulnerability.save!
  rescue => e
    pp "Import error #{line} - #{e}"
  end
end
