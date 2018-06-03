# frozen_string_literal: true

module ScanResult::Ransackers
  extend ActiveSupport::Concern

  included do

    ransacker :ip_str do
      Arel.sql("scan_results.ip::text")
    end

    ransacker :port_str do
      Arel.sql("scan_results.port::text")
    end

    ransacker :state_str do
      field_transformation = <<~SQL
        CASE scan_results.state
        WHEN 0
        THEN '#{ScanResult.human_enum_name(:states, 'closed')}'
        WHEN 1
        THEN '#{ScanResult.human_enum_name(:states, 'closed_filtered')}'
        WHEN 2
        THEN '#{ScanResult.human_enum_name(:states, 'filtered')}'
        WHEN 3
        THEN '#{ScanResult.human_enum_name(:states, 'unfiltered')}'
        WHEN 4
        THEN '#{ScanResult.human_enum_name(:states, 'open_filtered')}'
        WHEN 5
        THEN '#{ScanResult.human_enum_name(:states, 'open')}'
        END
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :legality_str do
      field_transformation = <<~SQL
        CASE scan_results.legality
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