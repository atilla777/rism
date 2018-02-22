require 'rails_helper'

RSpec.describe OrganizationKind, type: :model do
  it { should validate_uniqueness_of(:name) }
  it { should validate_length_of(:name)
      .is_at_least(1)
      .is_at_most(100) }
  it { should have_many(:organizations) }
end
