# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'incident management', type: :feature do
  given(:resource) { :incident }
  given(:resource_class) { Incident }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'Not allowable network traffic' }

  def fill_in_new
    fill_in 'incident[event_description]', with: resource_attribute_value
  end

  include_examples 'manage record'
end
