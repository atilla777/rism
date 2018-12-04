# frozen_string_literal: true

module ScanJobLog::Ransackers
  extend ActiveSupport::Concern
  included do

    ransacker :start_str do
      Arel.sql("to_char(start, 'DD.MM.YYYY')")
    end

    ransacker :finish_str do
      Arel.sql("to_char(finish, 'DD.MM.YYYY')")
    end

    ransacker :status do
      field_transformation = <<~SQL
        CASE
        WHEN scan_job_logs.finish IS NOT NULL
        THEN lower('#{I18n.t('labels.scan_job_logs.finished')}')
        ELSE lower('#{I18n.t('labels.scan_job_logs.started')}')
        END
      SQL
      Arel.sql(field_transformation)
    end

    ransacker :distance do
      field_transformation = <<~SQL
        CASE
        WHEN scan_job_logs.finish IS NOT NULL
        THEN finish - start
        ELSE NOW() - start
        END
      SQL
      Arel.sql(field_transformation)
    end
  end
end
