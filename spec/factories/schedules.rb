FactoryBot.define do
  factory :schedule do
    job { |j| j.association(:scan_job) }
    minutes []
    hours []
    week_days []
    months []
    month_days []
  end
end
