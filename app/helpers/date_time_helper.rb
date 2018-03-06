# frozen_string_literal: true

module DateTimeHelper
  def show_date(field)
    return '' unless field
    field.strftime('%d.%m.%Y')
  end

  def show_date_time(field)
    return '' unless field
    field.strftime('%d.%m.%Y-%H:%M')
  end
end
