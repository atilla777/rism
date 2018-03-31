# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Agreement management', type: :feature do
  given(:resource) { :agreement }
  given(:resource_class) { Agreement }
  given(:resource_attribute) { :prop }
  given(:resource_attribute_value) { 'Saved!' }
  given(:contractor) do
    create(
      :organization,
      name: 'Contractor',
      parent_id: organization.id
    )
  end

  def fill_in_new
    fill_in 'agreement[prop]', with: resource_attribute_value
    find("a[data-set-date='beginning']").click
    fill_in_autocomplete('organization', organization.name[0, 3])
    fill_in_autocomplete('contractor', contractor.name[0, 3])
  end

  include_examples 'manage organization record'
end
