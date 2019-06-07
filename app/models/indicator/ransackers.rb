# frozen_string_literal: true

class Indicator
  module Ransackers
    extend ActiveSupport::Concern
    include RansackerDatetimeCast

    included do
      ransacker :investigation_full_name do
        Arel.sql("'#' || investigations.id::text || ': ' || investigations.name")
      end

      ransacker :created_at_reverse_str do
        RansackerDatetimeCast.datetime_field_to_text_search 'indicators', 'created_at', :reverse
      end

      ransacker :custom_fields_str do

        Arel.sql( <<~SQL
                investigations.custom_fields::text
          SQL
        )
      end
#        Arel.sql( <<~SQL
#            concat_ws(
#              ' ',
#                (SELECT value FROM jsonb_each_text(investigations.custom_fields) )
#            )
#          SQL
#        )
#      end
#      ransacker :custom_fields_str do
#        Arel.sql("concat_ws(' ', (jsonb_each_text(investigations.custom_fields)))")
#      end

#      SELECT *
#      FROM   tbl
#      WHERE  EXISTS (SELECT FROM jsonb_each_text(jsonb_column) WHERE value ~* 'val');

      ransacker :content_format_str do
        field_transformation = <<~SQL
          CASE indicators.content_format
          WHEN 'other'
          THEN '#{Indicator.human_enum_name(:content_format, 'other')}'
          WHEN 'network_service'
          THEN '#{Indicator.human_enum_name(:content_format, 'network_service')}'
          WHEN 'network'
          THEN '#{Indicator.human_enum_name(:content_format, 'network')}'
          WHEN 'network_port'
          THEN '#{Indicator.human_enum_name(:content_format, 'network_port')}'
          WHEN 'email_adress'
          THEN '#{Indicator.human_enum_name(:content_format, 'email_adress')}'
          WHEN 'email_author'
          THEN '#{Indicator.human_enum_name(:content_format, 'email_author')}'
          WHEN 'email_theme'
          THEN '#{Indicator.human_enum_name(:content_format, 'email_theme')}'
          WHEN 'email_content'
          THEN '#{Indicator.human_enum_name(:content_format, 'email_content')}'
          WHEN 'uri'
          THEN '#{Indicator.human_enum_name(:content_format, 'uri')}'
          WHEN 'domain'
          THEN '#{Indicator.human_enum_name(:content_format, 'domain')}'
          WHEN 'md5'
          THEN '#{Indicator.human_enum_name(:content_format, 'md5')}'
          WHEN 'sha256'
          THEN '#{Indicator.human_enum_name(:content_format, 'sha256')}'
          WHEN 'sha512'
          THEN '#{Indicator.human_enum_name(:content_format, 'sha512')}'
          WHEN 'filename'
          THEN '#{Indicator.human_enum_name(:content_format, 'filename')}'
          WHEN 'filesize'
          THEN '#{Indicator.human_enum_name(:content_format, 'filesize')}'
          WHEN 'process'
          THEN '#{Indicator.human_enum_name(:content_format, 'process')}'
          WHEN 'account'
          THEN '#{Indicator.human_enum_name(:content_format, 'account')}'
          END
        SQL
        Arel.sql(field_transformation)
      end

      ransacker :trust_level_str do
        field_transformation = <<~SQL
          CASE indicators.trust_level
          WHEN 'not_set'
          THEN '#{Indicator.human_enum_name(:trust_level, 'not_set')}'
          WHEN 'low'
          THEN '#{Indicator.human_enum_name(:trust_level, 'low')}'
          WHEN 'high'
          THEN '#{Indicator.human_enum_name(:trust_level, 'high')}'
          END
        SQL
        Arel.sql(field_transformation)
      end

      ransacker :purpose_str do
        field_transformation = <<~SQL
          CASE indicators.purpose
          WHEN 'not_set'
          THEN '#{Indicator.human_enum_name(:purpose, 'not_set')}'
          WHEN 'for_detect'
          THEN '#{Indicator.human_enum_name(:purpose, 'for_detect')}'
          WHEN 'for_prevent'
          THEN '#{Indicator.human_enum_name(:purpose, 'for_prevent')}'
          END
        SQL
        Arel.sql(field_transformation)
      end
    end
  end
end
