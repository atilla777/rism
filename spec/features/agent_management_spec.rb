# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Agent management', type: :feature do
  given(:resource) { :agent }
  given(:resource_class) { Agent }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'My agent' }

  def fill_in_new
    fill_in 'agent[name]', with: resource_attribute_value
    fill_in 'agent[hostname]', with: 'My host'
    fill_in 'agent[port]', with: '443'
    fill_in 'agent[secret]', with: 'secret'
    fill_in_autocomplete('organization', organization.name[0, 3])
  end

  include_examples 'manage organization record'
end
