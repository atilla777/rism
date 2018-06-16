# frozen_string_literal: true

module OrganizationAssociated
  extend ActiveSupport::Concern
  include OrganizationRelative

#  included do
#    belongs_to :organization, optional: true
#  end

  def top_level_organizations
    Organization.top_level_organizations(organization_id)
  end
end
