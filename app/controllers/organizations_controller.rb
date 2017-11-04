class OrganizationsController < ApplicationController
  include DefaultActions

  autocomplete :organization, :name, full: true

  def active_record_get_autocomplete_items(parameters)
    authorize get_model
    super(parameters).where(id: current_user.allowed_organizations_ids)

    #organizations_ids = OrganizationPolicy::Scope.new(current_user, Organization)
    #                                             .resolve
    #                                             .pluck(:id)
  end

  private
  def get_model
    Organization
  end
end
