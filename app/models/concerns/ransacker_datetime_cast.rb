module RansackerDatetimeCast
  def datetime_field_to_text_search(table, fieled, reverse = nil)
    if reverse
      format = 'DD.MM.YYYY-HH24:MI'
    else
      format = 'YYYY.MM.DD-HH24:MI'
    end
    field_transformation = <<~SQL
      to_char(
        ((#{table}.#{fieled} AT TIME ZONE 'UTC') AT TIME ZONE '#{timezone_name}'),
          '#{format}'
      )
    SQL
    Arel.sql field_transformation
  end

  def timezone_name
    ActiveSupport::TimeZone.find_tzinfo(Time.zone.name).identifier
  end

  module_function :datetime_field_to_text_search, :timezone_name
end
