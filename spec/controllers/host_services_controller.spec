# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HostServicesController, type: :controller do
  include_examples 'organization record', :host_service

  let(:new_record) do
    post(
      :create,
      params: {
        model => attributes_for(model)
        .merge(organization_id: organization.id)
        .merge(host_id: organization.id)
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
          host_id: host.id
       }
      }
    )
  end
end
