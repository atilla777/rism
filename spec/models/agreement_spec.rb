require 'rails_helper'

RSpec.describe Agreement, type: :model do
  describe '#beginning' do
    it { should validate_presence_of(:beginning) }
  end

  describe '#prop' do
    it { should validate_length_of(:prop)
         .is_at_least(1)
         .is_at_most(100) }
  end

  describe '#organization_id' do
    it { should validate_numericality_of(:organization_id).only_integer }
  end

  describe '#agreement_kind_id' do
    it { should validate_numericality_of(:agreement_kind_id).only_integer }
  end

  describe '#contractor_id' do
    it { should validate_numericality_of(:contractor_id).only_integer }
  end

  it { should belong_to :organization }
  it { should belong_to :contractor}
  it { should belong_to :agreement_kind }
  it { should belong_to :agreement_kind }
  it { should have_many :attachment_links }
  it { should have_many :attachments }
end
