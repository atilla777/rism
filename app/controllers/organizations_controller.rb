class OrganizationsController < ApplicationController
  include DefaultActions

  autocomplete :organization, :name, full: true

  before_action :filter_parent_id, only: [:create, :update]

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
  def record_params
    params.require(get_model.name.underscore.to_sym)
          .permit(policy(get_model).permitted_attributes)
          #.merge current_user: current_user
  end

  def get_model
    Organization
  end

  def filter_parent_id
    id = params[get_model.name.underscore.to_sym][:parent_id].to_i
    unless current_user.admin_editor? || current_user.allowed_organizations_ids.include?(id)
      params[get_model.name.underscore.to_sym][:parent_id] = nil
    end
  end
end
