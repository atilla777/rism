require 'rails_helper'

RSpec.describe IndicatorContext, type: :model do
  it { should validate_uniqueness_of(:name) }
  it { should validate_length_of(:name)
       .is_at_least(3)
       .is_at_most(200) }
  it { should validate_uniqueness_of(:codename) }
  it { should validate_length_of(:codename)
       .is_at_least(1)
       .is_at_most(100) }
  it { should have_many(:indicator_context_members) }
end
