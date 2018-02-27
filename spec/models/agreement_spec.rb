require 'rails_helper'

RSpec.describe Agreement, type: :model do
  it 'should`t have contractor and organization the same company' do
    organization = create(:organization)
    contractor = organization
    agreement = Agreement.new(organization_id: organization.id, contractor_id: contractor.id)
    agreement.valid?

    expect(agreement.errors[:organization_id]).to be
    expect(agreement.errors[:contractor_id]).to be
  end

  it { should validate_presence_of(:beginning) }
  it { should validate_length_of(:prop)
     .is_at_least(1)
     .is_at_most(100) }
  it { should validate_uniqueness_of(:beginning)
       .scoped_to(:prop)
       .scoped_to(:organization_id) }
  it { should validate_numericality_of(:organization_id).only_integer }
  it { should validate_numericality_of(:agreement_kind_id).only_integer }
  it { should validate_numericality_of(:contractor_id).only_integer }
  it { should belong_to :organization }
  it { should belong_to :contractor}
  it { should belong_to :agreement_kind }
  it { should have_many :attachment_links }
  it { should have_many :attachments }
  it { should have_many :rights}
  it { should have_many :tags}
end
