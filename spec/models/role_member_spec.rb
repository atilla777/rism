require 'rails_helper'

RSpec.describe RoleMember, type: :model do
  describe '#user_id' do
    it { should validate_numericality_of(:user_id).only_integer }
  end

  describe '#role_id' do
    it { should validate_numericality_of(:role_id).only_integer }
  end

  it { should belong_to(:user) }
  it { should belong_to(:role) }
end
