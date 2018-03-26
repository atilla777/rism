# frozen-string_literal: true

require 'rails_helper'

RSpec.describe IncidentsController, type: :controller do
  include_examples 'organization record', :incident

  let(:new_record) do
    post(
      :create,
      params: {
        model => attributes_for(model)
        .merge(organization_id: organization.id)
        .merge(respond_to?(:user) ? {user_id: user.id} : {})
      }
    )
  end

  let(:update_record) do
    put(
      :update,
      params: {
        id: record.id,
        model => {
          investigation_description: 'New description',
          organization_id: organization.id
       }
      }
    )
  end
end
