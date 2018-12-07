# frozen_string_literal: true

module HostService::Ransackers
  extend ActiveSupport::Concern

  included do
    ransacker :port_str do
      Arel.sql("host_services.port::text")
    end

    ransacker :ip_str do
      Arel.sql("hosts.ip::text")
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

    ransacker :state_str do
      field_transformation = <<~SQL
        CASE scan_results.state
        WHEN 0
        THEN '#{ScanResult.human_attribute_states[0]}'
        WHEN 1
        THEN '#{ScanResult.human_attribute_states[1]}'
        WHEN 2
        THEN '#{ScanResult.human_attribute_states[2]}'
        WHEN 3
        THEN '#{ScanResult.human_attribute_states[3]}'
        WHEN 4
        THEN '#{ScanResult.human_attribute_states[4]}'
        WHEN 5
        THEN '#{ScanResult.human_attribute_states[5]}'
        ELSE '#{HostService.human_attribute_name(:unknown_state)}'
        END
      SQL
      Arel.sql(field_transformation)
    end
  end
end
