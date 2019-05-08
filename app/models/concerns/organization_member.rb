# frozen_string_literal: true

module OrganizationMember
  extend ActiveSupport::Concern
  include OrganizationRelative

  included do
    validates :organization_id,
      numericality: { only_integer: true },
      unless: :organization?

    #TODO: move optianal: true to concrect model
    belongs_to :organization, optional: true
  end

  def top_level_organizations
    id_of_organization = organization? ? id : organization_id
    Organization.top_level_organizations(id_of_organization)
  end

  private

  def organization?
    model_name == 'Organization'
  end
end
