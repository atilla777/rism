# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Scan option management', type: :feature do
  given(:resource) { :scan_option}
  given(:resource_class) { ScanOption }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'Fast nmap scan' }

  def fill_in_new
    fill_in 'scan_option[name]', with: resource_attribute_value
  end

  include_examples 'manage record'
end
