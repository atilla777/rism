# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Department management', type: :feature do
  given(:resource) { :department }
  given(:resource_class) { Department }
  given(:resource_attribute) { :name }
  include_examples 'manage organization record'
end
