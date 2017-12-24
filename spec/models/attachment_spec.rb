require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should validate_length_of(:name)
       .is_at_least(0)
       .is_at_most(100) }
  it { should validate_numericality_of(:organization_id)
       .only_integer }
  it { should belong_to(:organization) }
  it { should have_many(:attachment_links) }
  it { should have_many(:agreements) }
  it { should have_many :rights}
end
