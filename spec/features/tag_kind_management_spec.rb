# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Tag kind management', type: :feature do
  given(:resource) { :tag_kind }
  given(:resource_class) { TagKind }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'Incident types' }

  def fill_in_new
    fill_in 'tag_kind[name]', with: resource_attribute_value
    fill_in 'tag_kind[code_name]', with: 'IC'
  end

  include_examples 'manage record'
end
