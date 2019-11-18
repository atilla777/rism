# frozen_string_literal: true

module OrganizationAssociated
  extend ActiveSupport::Concern
  include OrganizationRelative

  def top_level_organizations
    Organization.top_level_organizations(organization_id)
  end
end
