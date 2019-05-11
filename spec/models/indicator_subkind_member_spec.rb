require 'rails_helper'

RSpec.describe IndicatorSubkindMember, type: :model do
  it { should validate_numericality_of(:indicator_id).only_integer }
  it { should validate_numericality_of(:indicator_subkind_id).only_integer }
  it { should belong_to(:indicator) }
  it { should belong_to(:indicator_subkind) }
end
