require 'rails_helper'

RSpec.describe Schedule, type: :model do
  it { should validate_inclusion_of(:hour).in_range(1..24) }
  it { should validate_inclusion_of(:week_day).in_range(0..6) }
  it { should validate_inclusion_of(:month_day).in_range(1..31) }

  it { should belong_to(:job) }
end
