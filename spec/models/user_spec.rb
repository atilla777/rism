require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_numericality_of(:rank)
       .only_integer }
  it { should validate_numericality_of(:department_id)
       .only_integer }
  it { should validate_length_of(:department_name)
       .is_at_least(0)
       .is_at_most(100) }
  it { should belong_to(:department) }

  # TODO make shared example for it
  describe '#organization_id' do
    it { should validate_numericality_of(:organization_id)
        .only_integer }

    context 'when creating and belongs to department' do
      it 'set organization_id' do
        organization = build(:organization)
        user = build(:user, organization_id: organization.id)

        expect(user.organization_id).to eq(organization.id)
      end
    end
  end

  describe '#email' do
    context 'when user allowed to login' do
      before(:each) { allow(subject).to receive(:active).and_return(true) }
      it { is_expected.to validate_presence_of(:email) }
    end

    context 'when user not allowed to login' do
      before { allow(subject).to receive(:active).and_return(false) }
      it { is_expected.not_to validate_presence_of(:email) }
    end
  end

  describe 'when user as access subject' do
    it { should have_many(:roles) }
    it { should have_many(:role_members) }
    it { should have_many(:rights) }

    context 'when user is main admin with id = 1' do
      it 'can`t be removed' do
        user = create(:user, id: 1)
        user.destroy

        expect(User.find(1)).to be
      end
    end

    context 'when user is admin' do
      it 'respond to #admin? as true' do
        user = create(:user)
        create(:role_member,
               user_id: user.id)

        expect(user.admin?).to be_truthy
      end
    end

    context 'when user is admin' do
      it 'respond to #admin? as true' do
        user = create(:user)
        create(:role_member,
               user_id: user.id)

        expect(user.admin?).to be_truthy
      end
    end
  end
end
