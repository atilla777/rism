class Schedule < ApplicationRecord
  validate :check_minutes
  validate :check_hours
  validate :check_week_days
  validate :check_months
  validate :check_month_days

  belongs_to :job, polymorphic: true

  private

  def check_minutes
    return if check_array(minutes, 0..59)
    errors.add(:minutes, :invalid)
  end

  def check_hours
    return if check_array(hours, 0..23)
    errors.add(:hours, :invalid)
  end

  def check_week_days
    return if check_array(week_days, 0..6)
    errors.add(:week_days, :invalid)
  end

  def check_months
    return if check_array(months, 1..12)
    errors.add(:months, :invalid)
  end

  def check_month_days
    return if check_array(month_days, 1..31)
    errors.add(:month_days, :invalid)
  end

  def check_array(array, range)
    array.is_a?(Array) && array.all?{|value| (range).include?(value)}
  end
end
