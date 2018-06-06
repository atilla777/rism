# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScanJobsController, type: :controller do
  include_examples 'organization record', :scan_job

  let(:new_record) do
    post(
      :create,
      params: {
        model => attributes_for(model)
        .merge(organization_id: organization.id)
        .merge(scan_option_id: create(:scan_option).id)
      }
    )
  end

  let(:update_record) do
    put(
      :update,
      params: {
        id: record.id,
        model => {
          description: 'New description',
          organization_id: organization.id
       }
      }
    )
  end
end
