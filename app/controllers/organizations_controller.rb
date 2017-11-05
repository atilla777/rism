class OrganizationsController < ApplicationController
  include DefaultActions
  include Organizatable

  autocomplete :organization, :name, full: true

  def active_record_get_autocomplete_items(parameters)
    authorize get_model
    if current_user.admin_editor?
      super(parameters)
    else
      super(parameters).where(id: current_user.allowed_organizations_ids)
    end

    #organizations_ids = OrganizationPolicy::Scope.new(current_user, Organization)
    #                                             .resolve
    #                                             .pluck(:id)
  end

  private
  def get_model
    Organization
  end
end
