require 'rails_helper'

RSpec.describe Role, type: :model do
  describe '#name' do
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
  end

  it { should have_many(:role_members) }
end
