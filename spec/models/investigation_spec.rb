require 'rails_helper'

RSpec.describe Investigation, type: :model do
  it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
  it { should validate_numericality_of(:organization_id).only_integer }
  it { should validate_numericality_of(:user_id).only_integer }
  it { should validate_numericality_of(:feed_id).only_integer }
  it { should belong_to :organization }
  it { should belong_to :user}
  it { should belong_to :feed}
#  it do
#    should validate_inclusion_of(:threat)
#      .in_array(Investigation.threats.keys)
#  end
end
