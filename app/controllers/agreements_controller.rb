class AgreementsController < ApplicationController
  include RecordOfOrganization

  before_action :set_attachment, only: [:show]

  private

  def model
    Agreement
  end

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
