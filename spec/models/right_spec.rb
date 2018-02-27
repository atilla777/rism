require 'rails_helper'

RSpec.describe Right, type: :model do
  it { should validate_numericality_of(:organization_id).only_integer }
  it { should validate_numericality_of(:subject_id).only_integer }
  it do
    should validate_inclusion_of(:subject_type)
      .in_array(Right.subject_types.keys)
  end
  it { should validate_inclusion_of(:level).in_range(1..3) }
  it { should belong_to(:subject) }
  it { should belong_to(:organization) }
  it { should belong_to(:role) }
end
