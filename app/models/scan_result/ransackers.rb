# frozen_string_literal: true

module ScanResult::Ransackers
  extend ActiveSupport::Concern
  included do

    ransacker :job_start_str do
      Arel.sql("to_char(job_start, 'DD.MM.YYYY')")
    end

    ransacker :finished_str do
      Arel.sql("to_char(finished, 'DD.MM.YYYY')")
    end

    ransacker :ip_str do
      Arel.sql("scan_results.ip::text")
    end

    ransacker :port_str do
      Arel.sql("scan_results.port::text")
    end

    ransacker :vulners_bool do
      field_transformation = <<~SQL
        CASE
        WHEN scan_results.vulners->0 IS NOT NULL
        THEN 'true'
        ELSE NULL
        END
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :vulners_str do
      field_transformation = <<~SQL
      (
        with vulns_table(arr) AS (
          select jsonb_array_elements(scan_results.vulners)
        )
        select
          string_agg(vulns_table.arr->>'cve', ' ')
          ||
          string_agg(vulns_table.arr->>'summary', ' ')
        from vulns_table
      )
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :host_service_legality do
      field_transformation = <<~SQL
      (
          select host_services.legality
          from host_services
          join hosts
          on hosts.id = host_services.host_id
          where hosts.ip = scan_results.ip
          and host_services.port = scan_results.port
          and host_services.protocol = scan_results.protocol
          limit 1
      )
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :host_service_status_id do
      field_transformation = <<~SQL
      (
          select host_services.host_service_status_id
          from host_services
          join hosts
          on hosts.id = host_services.host_id
          where hosts.ip = scan_results.ip
          and host_services.port = scan_results.port
          and host_services.protocol = scan_results.protocol
          limit 1
      )
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :host_service_description do
      field_transformation = <<~SQL
      (
          select host_services.description
          from host_services
          join hosts
          on hosts.id = host_services.host_id
          where hosts.ip = scan_results.ip
          and host_services.port = scan_results.port
          and host_services.protocol = scan_results.protocol
          limit 1
      )
      SQL
      Arel.sql(field_transformation)
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
