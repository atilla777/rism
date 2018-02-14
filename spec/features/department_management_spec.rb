# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Department management', type: :feature do
  given(:resource) { :department }
  given(:resource_class) { Department }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'Best agreement' }

  def fill_in_new
    fill_in 'department[name]', with: resource_attribute_value
    fill_in_autocomplete('organization', organization.name[0, 3])
  end

  include_examples 'manage organization record'
end
