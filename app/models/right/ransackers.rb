# frozen_string_literal: true

module Right::Ransackers
  extend ActiveSupport::Concern

  included do
    ransacker :subject_type do
      request = 'CASE rights.subject_type '
      request = subject_types.sum(request) do |(subject_code, subject_name)|
        <<~SQL
          WHEN '#{subject_code}'
          THEN '#{subject_name}'
        SQL
      end
      request << 'END'
      Arel.sql(request)
    end
  end
end
