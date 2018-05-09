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
end
