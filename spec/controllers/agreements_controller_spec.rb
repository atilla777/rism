# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AgreementsController, type: :controller do
  include_examples 'organization record', :agreement

  let(:new_record) do
    post(
      :create,
      params: {
        model => attributes_for(model)
        .merge(organization_id: organization.id)
        .merge(contractor_id: not_allowed_organization.id)
        .merge(agreement_kind_id: create(:agreement_kind).id)
      }
    )
  end
end
