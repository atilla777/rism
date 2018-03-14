# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecordTemplatesController, type: :controller do
  include_examples 'record', :agreement_kind
end
