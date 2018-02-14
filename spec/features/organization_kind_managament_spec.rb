# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Organization kind management', type: :feature do
  given(:resource) { :organization_kind }
  given(:resource_class) { OrganizationKind }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'JSC' }

  def fill_in_new
    fill_in 'organization_kind[name]', with: resource_attribute_value
  end

  include_examples 'manage record'
end
