# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagKindsController, type: :controller do
  include_examples 'record', :tag_kind
end
