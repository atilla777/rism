# frozen_string_literal: true

class DeliveryListsController < ApplicationController
  include RecordOfOrganization

  autocomplete(
    :delivery_list,
    :prop,
    extra_data: %i[organization_id]
  )

  # authorization for autocomplete
  def active_record_get_autocomplete_items(parameters)
    authorize model
    if current_user.admin_editor?
      super(parameters)
      .includes(:organization, :contractor)
    else
      super(parameters)
      .where(organization_id: current_user.allowed_organizations_ids)
      .or(
        super(parameters)
        .where(contractor_id: current_user.allowed_organizations_ids)
      )
      .includes(:organization, :contractor)
    end
  end

  private

  def model
    DeliveryList
  end

  def records_includes
    %i[organization]
  end
end
