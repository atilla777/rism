# frozen_string_literal: true

module HostService::Ransackers
  extend ActiveSupport::Concern

  included do
    ransacker :port_str do
      Arel.sql("host_services.port::text")
    end

    ransacker :vulnerable_str do
      field_transformation = <<~SQL
        CASE
        WHEN host_services.vulnerable = 'true'
        THEN '#{ScanResult.human_attribute_name(:vulns)}'
        ELSE ''
        END
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :legality_str do
      field_transformation = <<~SQL
        CASE host_services.legality
        WHEN 0
        THEN '#{ScanResult.human_enum_name(:legalities, 'illegal')}'
        WHEN 1
        THEN '#{ScanResult.human_enum_name(:legalities, 'unknown')}'
        WHEN 2
        THEN '#{ScanResult.human_enum_name(:legalities, 'legal')}'
        WHEN 3
        THEN '#{ScanResult.human_enum_name(:legalities, 'no_sense')}'
        END
      SQL
      Arel.sql(field_transformation)
    end
  end
end
