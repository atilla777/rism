require 'rails_helper'
RSpec.describe ScanOption, type: :model do
  it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:scan_jobs) }
end
