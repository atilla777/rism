# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Agreement kind management', type: :feature do
  given(:resource) { :agreement_kind }
  given(:resource_class) { AgreementKind }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'NDA agreement' }

  def fill_in_new
    fill_in 'agreement_kind[name]', with: resource_attribute_value
  end

  include_examples 'manage record'
end
