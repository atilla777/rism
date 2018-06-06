# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'incident management', type: :feature do
  given(:resource) { :incident }
  given(:resource_class) { Incident }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'Virus' }

  def fill_in_new
    fill_in 'incident[name]', with: resource_attribute_value
    fill_in 'incident[event_description]', with: 'Ping detected!'
    find('a[href="#toggle_owners"]').click
    fill_in_autocomplete('organization', organization.name[0, 3])
  end

  include_examples 'manage organization record'
end
