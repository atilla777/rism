module DateTimeHelper
  def show_date(field)
    field.strftime("%d.%m.%Y")
  end

  def show_date_time(field)
    field.strftime("%d.%m.%Y-%H:%m")
  end
end
