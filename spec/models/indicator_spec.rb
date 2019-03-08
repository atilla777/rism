require 'rails_helper'

RSpec.describe Indicator, type: :model do
  it { should validate_numericality_of(:investigation_id).only_integer }
  it { should validate_numericality_of(:user_id).only_integer }
#  it { should validate_numericality_of(:ioc_kind).only_integer }
#  it { should validate_numericality_of(:trust_level).only_integer }
  it { should validate_presence_of :content}
  it { should belong_to :investigation}
#  it do
#    should validate_inclusion_of(:threat)
#      .in_array(Indicator.ioc_kinds.keys)
#  end
#  it do
#    should validate_inclusion_of(:trust_level)
#      .in_array(Indicator.trust_levels.keys)
#  end
end
