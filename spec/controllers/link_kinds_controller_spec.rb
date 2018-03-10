# frosen_string_literal: true

require 'rails_helper'

RSpec.describe LinkKindsController, type: :controller do
  include_examples 'record', :link_kind
end
