require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  should validate_uniqueness_of(:name)
  should validate_numericality_of(:parent_id).only_integer
end
