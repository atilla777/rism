# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagMember, type: :model do
  it { should validate_numericality_of(:record_id).only_integer }
  it { should validate_numericality_of(:tag_id).only_integer }
  it do
    should validate_inclusion_of(:record_type)
      .in_array(TagMember.record_types)
  end
  it { should belong_to(:record) }
  it { should belong_to(:tag) }
end
