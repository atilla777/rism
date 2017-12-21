require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#email' do
    context 'User is allowed to login' do
      before(:each) { allow(subject).to receive(:active).and_return(true) }
      it { is_expected.to validate_presence_of(:email) }
    end

    context 'User is not allowed to login' do
      before { allow(subject).to receive(:active).and_return(false) }
      it { is_expected.not_to validate_presence_of(:email) }
    end
  end

  it { should validate_numericality_of(:organization_id)
       .only_integer }
  it { should validate_numericality_of(:job_rank)
       .only_integer }
  it { should validate_numericality_of(:department_id)
       .only_integer }
  it { should validate_length_of(:department_name)
       .is_at_least(0)
       .is_at_most(100) }
  it { should belong_to(:department) }
  it { should have_many(:rights) }

  describe 'user as access subject' do
    it { should have_many(:roles) }
    it { should have_many(:role_members) }
  end
end
