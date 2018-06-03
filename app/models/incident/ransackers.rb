# frozen_string_literal: true

module Incident::Ransackers
  extend ActiveSupport::Concern

  included do
    ransack_alias :incident, :sharp_id_or_name_or_tags_name_or_tag_code_name_or_tag_kinds_name_or_incident_organizations_name_or_created_at_reverse_str_or_severity_str_or_damage_str_or_state_str_or_user_name

    def self.datetime_field_to_text_search(fieled, reverse = nil)
      if reverse
        format = 'DD.MM.YYYY-HH24:MI'
      else
        format = 'YYYY.MM.DD-HH24:MI'
      end
      field_transformation = <<~SQL
        to_char(
          ((incidents.#{fieled} AT TIME ZONE 'UTC') AT TIME ZONE '#{timezone_name}'),
            '#{format}'
        )
      SQL
      Arel.sql field_transformation
    end

    def self.timezone_name
      ActiveSupport::TimeZone.find_tzinfo(Time.zone.name).identifier
    end

    ransacker :sharp_id do
      Arel.sql("'#' || incidents.id::text")
    end

    ransacker :tag_code_name do
      field_transformation = <<~SQL
        tag_kinds.code_name || tags.rank::text
      SQL
      Arel.sql(field_transformation)
    end

#    ransacker :discovered_at_str do
#      datetime_field_to_text_search 'discovered_at'
#    end
#
#    ransacker :started_at_str do
#      datetime_field_to_text_search 'started_at'
#    end
#
#    ransacker :created_at_str do
#      datetime_field_to_text_search 'created_at'
#    end

    ransacker :created_at_reverse_str do
      datetime_field_to_text_search 'created_at', :reverse
    end

#    ransacker :finished_at_str do
#      datetime_field_to_text_search 'finished_at'
#    end
#
#    ransacker :closed_at_str do
#      datetime_field_to_text_search 'closed_at'
#    end

    ransacker :severity_str do
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

    ransacker :damage_str do
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

    ransacker :state_str do
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
  end
end
