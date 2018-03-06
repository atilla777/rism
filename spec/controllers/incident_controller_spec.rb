# frozen-string_literal: true

require 'rails_helper'

RSpec.describe IncidentsController, type: :controller do
  include_examples 'record', :incident

  let(:new_record) do
    post(
      :create,
      params: {
        model => attributes_for(model)
      }
    )
  end
end
