# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User management', type: :feature do
  given(:resource) { :user }
  given(:resource_class) { User }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'Vasia' }

  def fill_in_new
    fill_in 'user[name]', with: resource_attribute_value
    fill_in_autocomplete('organization', organization.name[0, 3])
  end

  include_examples 'manage organization record'
  # TODO: fix error - button  wheh create new User not pressed
end
