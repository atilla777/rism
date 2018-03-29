# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HostsController, type: :controller do
  include_examples 'organization record', :host

  let(:new_record) do
    post(
      :create,
      params: {
        model => attributes_for(model)
        .merge(organization_id: organization.id)
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
