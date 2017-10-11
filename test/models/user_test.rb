require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:email)
end
