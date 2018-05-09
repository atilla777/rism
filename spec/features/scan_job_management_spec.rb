# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Scan job management', type: :feature do
  given(:resource) { :scan_job}
  given(:resource_class) { ScanJob }
  given(:resource_attribute) { :name}
  given(:resource_attribute_value) { 'Saved!' }

  def fill_in_new
    fill_in 'scan_job[name]', with: resource_attribute_value
    fill_in 'scan_job[hosts]', with: '10.1.1.1'
    fill_in_autocomplete('organization', organization.name[0, 3])
  end

  include_examples 'manage organization record'
end
