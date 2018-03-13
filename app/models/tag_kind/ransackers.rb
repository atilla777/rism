# frozen_string_literal: true

module TagKind::Ransackers
  extend ActiveSupport::Concern

  included do
    ransacker :record_type do
      request = 'CASE tag_kinds.record_type '
      request = record_types.sum(request) do |(record_code, record_name)|
        <<~SQL
          WHEN '#{record_code}'
          THEN '#{record_name}'
        SQL
      end
      request << 'END'
      Arel.sql(request)
    end
  end
end
