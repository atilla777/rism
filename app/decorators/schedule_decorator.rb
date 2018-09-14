# frozen_string_literal: true

class ScheduleDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_month_days
    month_days.sort.each_with_object([]) do |day, memo|
      memo << day
    end.join(', ')
  end

  def show_months
    months.sort.each_with_object([]) do |month, memo|
      memo << I18n.t('date.month_names2')[month]
    end.join(', ')
  end

  def show_week_days
    week_days.sort.each_with_object([]) do |week_day, memo|
      memo << I18n.t('date.day_names')[week_day]
    end.join(', ')
  end
end
