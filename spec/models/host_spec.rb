require 'rails_helper'

RSpec.describe Host, type: :model do
  it { should validate_length_of(:name).is_at_least(3).is_at_most(200) }
  it { should validate_uniqueness_of(:name)
        .scoped_to(:organization_id) }
  it { should validate_uniqueness_of(:ip) }
  it { should validate_numericality_of(:organization_id).only_integer }
  it { should belong_to(:organization) }
  it { should have_many(:scan_jobs) }
end
