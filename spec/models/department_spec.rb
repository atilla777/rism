require 'rails_helper'

RSpec.describe Department, type: :model do
  it { should validate_length_of(:name)
       .is_at_least(1)
       .is_at_most(100) }
  it { should validate_uniqueness_of(:name)
        .scoped_to(:organization_id) }
  it { should validate_numericality_of(:organization_id)
       .only_integer }
  it { should validate_numericality_of(:parent_id)
       .only_integer }
  it { should validate_numericality_of(:rank)
       .only_integer }

  it { should have_many(:users) }
  it { should have_many(:rights) }
  it { should have_many(:children) }
  it { should belong_to(:parent) }

  context 'when have parents' do
    let(:foreign_department) { create(:department) }
    let(:grand_parent_department) { create(:department) }
    let(:parent_department) { create(:department,
                              parent_id: grand_parent_department.id) }
    let(:child_department) { create(:department, parent_id: parent_department.id) }

    describe '#top_level_departments' do
      it 'return only parents department ids' do
        foreign_department
        grand_parent_department
        parent_department
        child_department
        top_level_departments = [grand_parent_department.id,
                                 parent_department.id,
                                 child_department.id]

        expect(child_department.top_level_departments.pluck(:id)).to match_array(top_level_departments)
      end
    end
  end
end
