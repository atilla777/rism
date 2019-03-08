require 'rails_helper'

RSpec.describe Feed, type: :model do
  it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
end
