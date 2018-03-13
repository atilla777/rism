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
    else
      super(parameters).where(
        organization_id: current_user.allowed_organizations_ids
      )
      .or(super(parameters).where(
          contractor_id: current_user.allowed_organizations_ids
        )
      )
    end
  end

  # TODO move code to attachable concern
  before_action :set_attachment, only: [:show]

  private

  def model
    Agreement
  end

  # TODO move code to attachable concern
  def set_attachment
    @attahment = Attachment.new
  end

  def filter_for_organization
    model.where(organization_id: @organization.id)
         .or(model.where(contractor_id: @organization.id))
  end

  def default_sort
    'beginning desc'
  end

  def default_includes
    %i[organization contractor agreement_kind]
  end
end
