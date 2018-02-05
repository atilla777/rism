# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DepartmentsController, type: :controller do
  include_examples 'organization record', :department

  let(:new_record) do
    post(
      :create,
      params: {
        model => attributes_for(model)
        .merge(organization_id: organization.id)
      }
    )
  end
end
