# frozen_string_literal: true

class AgreementsController < ApplicationController
  include RecordOfOrganization

  autocomplete(
    :agreement,
    :prop,
    extra_data: %i[beginning organization_id contractor_id],
    display_value: :show_full_name
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

  # TODO: use or delete
  # before_action :set_attachment, only: [:show]

  private

  def model
    Agreement
  end

  # TODO: use or delete
#  def set_attachment
#    @attahment = Attachment.new
#  end

  def filter_for_organization
    model.where(organization_id: @organization.id)
         .or(model.where(contractor_id: @organization.id))
  end

  def default_sort
    'beginning desc'
  end

  def records_includes
    %i[organization contractor agreement_kind]
  end
end
