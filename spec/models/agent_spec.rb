require 'rails_helper'

RSpec.describe Agent, type: :model do
  it { should validate_uniqueness_of(:name)
    .scoped_to(:organization_id)}
  it { should validate_length_of(:name)
    .is_at_least(3).is_at_most(250) }
  it { should validate_numericality_of(:organization_id)
      .only_integer }

  it { should have_many(:scan_jobs) }
  it { should have_many(:scan_job_logs) }
  it { should belong_to(:organization) }
end
