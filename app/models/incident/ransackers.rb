# frozen_string_literal: true

module Incident::Ransackers
  extend ActiveSupport::Concern
  include RansackerDatetimeCast

  included do
    ransack_alias :incident, :sharp_id_or_name_or_tags_name_or_tag_code_name_or_tag_kinds_name_or_incident_organizations_name_or_created_at_reverse_str_or_severity_str_or_damage_str_or_state_str_or_user_name

    ransacker :sharp_id do
      Arel.sql("'#' || incidents.id::text")
    end

    ransacker :tag_code_name do
      field_transformation = <<~SQL
        tag_kinds.code_name || tags.rank::text
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :created_at_reverse_str do
      RansackerDatetimeCast.datetime_field_to_text_search 'incidents', 'created_at', :reverse
    end

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
