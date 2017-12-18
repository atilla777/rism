require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe '#name' do
    it { should validate_length_of(:name)
         .is_at_least(1)
         .is_at_most(100) }
    it { should validate_uniqueness_of(:name) }
  end

  describe '#full_name' do
    it { should validate_length_of(:full_name)
         .is_at_least(0)
         .is_at_most(200) }
    it { should validate_uniqueness_of(:full_name) }
  end

  describe '#parent_id' do
    it { should validate_numericality_of(:parent_id).only_integer }
  end

  it { should have_many(:users) }
  it { should have_many(:departments) }
  it { should have_many(:agreements) }
  it { should have_many(:contracts) }
  it { should have_many(:rights) }
  it { should have_many(:right_scopes) }
  it { should have_many(:children) }

  it { should belong_to(:parent) }

  context 'Organization has some child organizations' do
    subject(:parent1) { create :organization }
    subject(:child1) { create :organization, parent_id: parent1 }
    subject(:child2) { create :organization, parent_id: child1 }
    describe '#down_level_organizations' do
      it 'return array of child ids' do

        expect(Organization.down_level_organizations(parent1.id))
          .to contain_exactly(child1.id, child2.id)
      end
    end
  end
end
