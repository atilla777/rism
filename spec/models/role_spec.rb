require 'rails_helper'

RSpec.describe Role, type: :model do
  describe '#name' do
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
  end

  it { should have_many(:role_members) }

  context 'when role is main admin role with id = 1' do
    it 'cant`t be deleted' do
      admin_role = create(:role, id: 1)
      admin_role.destroy

      expect(Role.where(id: 1).first).to be
    end
  end

  context 'when role is main editor role with id = 2' do
    it 'cant`t be deleted' do
      admin_role = create(:role, id: 2)
      admin_role.destroy

      expect(Role.where(id: 2).first).to be
    end
  end

  context 'when role is main reader role with id = 3' do
    it 'cant`t be deleted' do
      admin_role = create(:role, id: 3)
      admin_role.destroy

      expect(Role.where(id: 3).first).to be
    end
  end
end
