# frozen_string_literal: true

module Indicator::Ransackers
  extend ActiveSupport::Concern
  include RansackerDatetimeCast

  included do
    ransacker :investigation_full_name do
      Arel.sql("'#' || investigations.id::text || ': ' || investigations.name")
    end

    ransacker :created_at_reverse_str do
      RansackerDatetimeCast.datetime_field_to_text_search 'indicators', 'created_at', :reverse
    end

    ransacker :ioc_kind_str do
      field_transformation = <<~SQL
        CASE indicators.ioc_kind
        WHEN 0
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'other')}'
        WHEN 1
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'network')}'
        WHEN 2
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'email_adress')}'
        WHEN 3
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'email_theme')}'
        WHEN 4
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'email_content')}'
        WHEN 5
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'url')}'
        WHEN 6
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'domain')}'
        WHEN 7
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'md5')}'
        WHEN 8
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'sha256')}'
        WHEN 9
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'sha512')}'
        WHEN 10
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'filename')}'
        WHEN 11
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'filesize')}'
        WHEN 12
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'process')}'
        WHEN 13
        THEN '#{Indicator.human_enum_name(:ioc_kind, 'account')}'
        END
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :trust_level_str do
      field_transformation = <<~SQL
        CASE indicators.trust_level
        WHEN 0
        THEN '#{Indicator.human_enum_name(:trust_level, 'unknown')}'
        WHEN 1
        THEN '#{Indicator.human_enum_name(:trust_level, 'low')}'
        WHEN 2
        THEN '#{Indicator.human_enum_name(:trust_level, 'high')}'
        END
      SQL
      Arel.sql(field_transformation)
    end
  end
end
