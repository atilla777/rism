# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagKind, type: :model do
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:code_name) }
  it { should validate_inclusion_of(:record_type).in_array(Link.record_types.keys) }
  it do
    should validate_length_of(:name)
      .is_at_least(1)
      .is_at_most(100)
  end
  it do
    should validate_length_of(:code_name)
      .is_at_least(1)
      .is_at_most(10)
  end
  it { should have_many(:tags) }
end
