class Schedule < ApplicationRecord
  validates :job_id, uniqueness: { scope: :job_type }
  validates :job_id, presence: true
  validates :job_type, presence: true

  validate :check_minutes
  validate :check_hours
  validate :check_week_days
  validate :check_months
  validate :check_month_days

  belongs_to :job, polymorphic: true

  has_one :organization, through: :job

  #delegate :organization, to: :job

  def show_crontab_line
    return crontab_line if crontab_line.present?
    # TODO: think and if you wants do it with postgres function
    result = []
    %i[minutes hours month_days months week_days].each do |arr|
      result << array_to_crontab_symbol(self.send(arr))
    end
    return nil if result.all? { |value| value == '*' }
    result.join(' ')
  end

  private

  def array_to_crontab_symbol(arr)
    arr.present? ? arr.join(',') : '*'
  end

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
