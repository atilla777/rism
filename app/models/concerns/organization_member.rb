# frozen_string_literal: true

module OrganizationMember
  extend ActiveSupport::Concern
  include OrganizationRelative

  included do
    belongs_to :organization, optional: true
  end

  def top_level_organizations
    id_of_organization = if model_name == 'Organization'
                           id
                         else
                           organization_id
                         end

    Organization.top_level_organizations(id_of_organization)
  end
end
