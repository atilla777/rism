# frozen_string_literal: true

module Investigation::Ransackers
  extend ActiveSupport::Concern
  include RansackerDatetimeCast

  included do
    ransacker :created_at_reverse_str do
      RansackerDatetimeCast.datetime_field_to_text_search 'investigations', 'created_at', :reverse
    end

    ransacker :threat_str do
      field_transformation = <<~SQL
        CASE investigations.threat
        WHEN 0
        THEN '#{Indicator.human_enum_name(:threat, 'other')}'
        WHEN 1
        THEN '#{Indicator.human_enum_name(:threat, 'network')}'
        WHEN 2
        THEN '#{Indicator.human_enum_name(:threat, 'email')}'
        WHEN 3
        THEN '#{Indicator.human_enum_name(:threat, 'process')}'
        WHEN 4
        THEN '#{Indicator.human_enum_name(:threat, 'account')}'
        END
      SQL
      Arel.sql(field_transformation)
    end
  end
end
