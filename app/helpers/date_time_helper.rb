# frozen_string_literal: true

module DateTimeHelper
  def show_date(field)
    return '' if field.blank?
    field.strftime('%d.%m.%Y')
  end

  def show_date_time(field)
    return '' if field.blank?
    field.strftime('%d.%m.%Y-%H:%M')
  end

  def time_value(record, field)
    return record.send(field) if record.send(field) && record
    nil
  end

  def start_year
    Date.current.year
  end

  def end_year
    15.years.ago.year
  end

end
