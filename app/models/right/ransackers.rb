# frozen_string_literal: true

module Right::Ransackers
  extend ActiveSupport::Concern

  LEVELS = {
    1 => I18n.t('rights.manager'),
    2 => I18n.t('rights.editor'),
    3 => I18n.t('rights.reader')
  }.freeze

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

    # TODO: try to make subject_type field transformation
    # (for search with translated model name)
    ransacker :level do
      field_transformation = <<~SQL
        CASE level
        WHEN 1
        THEN '#{LEVELS[3]}'
        WHEN 2
        THEN '#{LEVELS[3]}'
        WHEN 3
        THEN '#{LEVELS[3]}'
        END
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :subject_id do
      Arel.sql('cast(subject_id as char)')
    end
  end
end
