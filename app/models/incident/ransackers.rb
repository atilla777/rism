# frozen_string_literal: true

module Incident::Ransackers
  extend ActiveSupport::Concern

  included do
    ransacker :id do
      Arel.sql(" '#' || incidents.id::char")
    end

    ransacker :discovered_at do
      datetime_field_to_text_search 'discovered_at'
    end

    ransacker :started_at do
      datetime_field_to_text_search 'started_at'
    end

    ransacker :created_at do
      datetime_field_to_text_search 'created_at'
    end

    ransacker :finished_at do
      datetime_field_to_text_search 'finished_at'
    end

    ransacker :closed_at do
      datetime_field_to_text_search 'closed_at'
    end

    ransacker :severity do
      field_transformation = <<~SQL
        CASE incidents.severity
        WHEN 0
        THEN '#{severities[0]}'
        WHEN 1
        THEN '#{severities[1]}'
        END
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :damage do
      field_transformation = <<~SQL
        CASE incidents.damage
        WHEN 0
        THEN '#{damages[0]}'
        WHEN 1
        THEN '#{damages[1]}'
        WHEN 2
        THEN '#{damages[2]}'
        END
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :state do
      field_transformation = <<~SQL
        CASE incidents.state
        WHEN 0
        THEN '#{states[0]}'
        WHEN 1
        THEN '#{states[1]}'
        WHEN 2
        THEN '#{states[2]}'
        END
      SQL
      Arel.sql(field_transformation)
    end

    def self.datetime_field_to_text_search(fieled)
      field_transformation = <<~SQL
        to_char(
          ((incidents.#{fieled} AT TIME ZONE 'UTC') AT TIME ZONE '#{timezone_name}'),
          'YYYY.MM.DD-HH24:MI'
        )
      SQL
      Arel.sql field_transformation
    end

    def self.timezone_name
      ActiveSupport::TimeZone.find_tzinfo(Time.zone.name).identifier
    end
  end
end
