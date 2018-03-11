# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Link kind management', type: :feature do
  given(:resource) { :link_kind }
  given(:resource_class) { LinkKind }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'Incident victim' }

  def fill_in_new
    fill_in 'link_kind[name]', with: resource_attribute_value
    fill_in 'link_kind[code_name]', with: 'OV1'
    fill_in 'link_kind[rank]', with: '1'
  end

  include_examples 'manage record'
end
