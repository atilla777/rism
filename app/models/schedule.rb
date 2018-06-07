class Schedule < ApplicationRecord
  validates :hour, inclusion: { in: 1..24, allow_blank: true }
  validates :week_day, inclusion: { in: 0..6, allow_blank: true }
  validates :month_day, inclusion: { in: 1..31, allow_blank: true }

  belongs_to :job, polymorphic: true
end
