# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should validate_numericality_of(:link_kind_id).only_integer }
  it { should validate_numericality_of(:first_record_id).only_integer }
  it do
    should validate_inclusion_of(:first_record_type)
      .in_array(Link.record_types.keys)
  end
  it { should validate_numericality_of(:second_record_id).only_integer }
  it do
    should validate_inclusion_of(:second_record_type)
      .in_array(Link.record_types.keys)
  end
  it do
    should validate_uniqueness_of(:first_record_type)
      .scoped_to(:link_kind_id)
      .scoped_to(:first_record_id)
      .scoped_to(:second_record_type)
      .scoped_to(:second_record_id)
  end
  it { should belong_to(:link_kind) }
  it { should belong_to(:first_record) }
  it { should belong_to(:second_record) }
end
