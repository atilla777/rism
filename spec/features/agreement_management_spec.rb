# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Agreement management', type: :feature do
  given(:resource) { :agreement }
  given(:resource_class) { Agreement }
  given(:resource_attribute) { :prop }
  include_examples 'feature organization record'
end
