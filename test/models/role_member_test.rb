require 'test_helper'

class RoleMemberTest < ActiveSupport::TestCase
  should validate_numericality_of(:user_id).only_integer
  should validate_numericality_of(:role_id).only_integer
  should belong_to(:user)
  should belong_to(:role)
end
