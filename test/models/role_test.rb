require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  should validate_uniqueness_of(:name)
  should validate_length_of(:name).is_at_least(3).is_at_most(100)
  should have_many(:role_members)
end
