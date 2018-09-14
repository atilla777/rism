# frozen_string_literal: true

module Schedule::Ransackers
  extend ActiveSupport::Concern

  included do
    ransacker :sharp_id do
      Arel.sql("'#' || schedules.id::text")
    end
    # TODO: User or delete
#    ransacker :month_str do
#      field_transformation = <<~SQL
#        CASE schedules.month
#        WHEN 0
#        THEN '#{states[0]}'
#        WHEN 1
#        THEN '#{states[1]}'
#        WHEN 2
#        THEN '#{states[2]}'
#        END
#      SQL
#      Arel.sql(field_transformation)
#    end
  end
end
