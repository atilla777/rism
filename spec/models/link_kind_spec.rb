# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinkKind, type: :model do
  it { should validate_length_of(:name).is_at_least(3).is_at_most(255) }
  it { should validate_uniqueness_of(:name).scoped_to(:first_record_type) }
  it { should validate_length_of(:code_name).is_at_least(1).is_at_most(10) }
  it { should validate_uniqueness_of(:code_name) }
  it { should validate_numericality_of(:rank).only_integer }
  it do
    should validate_inclusion_of(:first_record_type).in_array(Link.record_types.keys)
  end
  it { should validate_inclusion_of(:second_record_type).in_array(Link.record_types.keys) }
  it { should allow_value(%w(true false)).for(:equal) }
  it { should have_many(:links) }
end
