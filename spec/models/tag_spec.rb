# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { should validate_length_of(:name).is_at_least(1).is_at_most(150) }
  it { should validate_uniqueness_of(:name).scoped_to(:tag_kind_id) }
  it { should validate_numericality_of(:rank).only_integer }
  it { should validate_numericality_of(:tag_kind_id).only_integer }
  it { should belong_to(:tag_kind) }
end
