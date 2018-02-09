# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User management', type: :feature do
  given(:resource) { :user }
  given(:resource_class) { User }
  given(:resource_attribute) { :name }
  include_examples 'manage organization record'
end
