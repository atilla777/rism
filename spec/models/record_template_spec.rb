# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecordTemplate, type: :model do
  it { should validate_uniqueness_of(:name) }
  it { should validate_length_of(:name).is_at_least(3).is_at_most(150) }
  it { should validate_presence_of(:record_content) }
  it { should validate_inclusion_of(:record_type).in_array(RecordTemplate.record_types.keys) }
end
