# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'incident management', type: :feature do
  given(:resource) { :incident }
  given(:resource_class) { Incident }
  given(:resource_attribute) { :event_description }
  given(:resource_attribute_value) { 'Something tireble was happened!' }

  def fill_in_new
    fill_in(
      'incident[discovered_at]',
      with: I18n.l(Time.zone.today, format: '%Y-%m-%d')
    )
    fill_in 'incident[event_description]', with: resource_attribute_value
  end

  include_examples 'manage record'
end
