require 'rails_helper'

RSpec.describe IndicatorContextMember, type: :model do
  it { should validate_numericality_of(:indicator_id).only_integer }
  it { should validate_numericality_of(:indicator_context_id).only_integer }
  it { should belong_to(:indicator) }
  it { should belong_to(:indicator_context) }
end
