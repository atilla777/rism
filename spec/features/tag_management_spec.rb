# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Tag management', type: :feature do
  given(:resource) { :tag }
  given(:resource_class) { Tag }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'Incident types' }
  given(:tag_kind) { create(:tag_kind) }

  before do
   tag_kind
  end

  def fill_in_new
   fill_in 'tag[name]', with: resource_attribute_value
   fill_in 'tag[rank]', with: 1
   select(tag_kind.name, from: 'tag[tag_kind_id]')
  end

  include_examples 'manage record'
end
