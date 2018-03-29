# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Host management', type: :feature do
  given(:resource) { :host}
  given(:resource_class) { Host }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'New IP' }

  def fill_in_new
    fill_in 'host[name]', with: resource_attribute_value
    fill_in 'host[ip]', with: '172.16.0.1'
    fill_in_autocomplete('organization', organization.name[0, 3])
  end

  include_examples 'manage organization record'
end
