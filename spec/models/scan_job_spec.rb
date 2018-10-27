require 'rails_helper'
RSpec.describe ScanJob, type: :model do
  it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
  it { should validate_uniqueness_of(:name).scoped_to(:organization_id) }
  it { should validate_numericality_of(:organization_id).only_integer }
  it { should validate_numericality_of(:scan_option_id).only_integer }
  it { should belong_to(:organization) }
  it { should belong_to(:scan_option) }

  it { should have_one(:schedule) }
  it { should have_many(:linked_hosts)}
end



