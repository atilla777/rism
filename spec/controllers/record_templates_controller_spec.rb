# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecordTemplatesController, type: :controller do
  include_examples 'record', :record_template

  let(:incident) { create :incident }
  let(:new_params) do
    {
      original_record_id: incident.id,
      original_record_type: 'Incident'
    }
  end
  let(:new_record) do
    post(
      :create,
      params: {model => attributes_for(model)}
        .merge(original_record_id: incident.id)
    )
  end
end
