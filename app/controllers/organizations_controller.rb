# frozen_string_literal: true

class OrganizationsController < ApplicationController
  include Record

  autocomplete :organization, :name, full: true

  before_action :filter_parent_id, only: %i[create update]

  def active_record_get_autocomplete_items(parameters)
    authorize model
    if current_user.admin_editor?
      super(parameters)
    else
      super(parameters).where(id: current_user.allowed_organizations_ids)
    end
  end

  def index
    authorize model
    scope = policy_scope(model)
    @q = scope.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @records = @q.result
                 .includes(:parent, :organization_kind)
                 .page(params[:page])
  end

  private

  def record_params
    params.require(model.name.underscore.to_sym)
          .permit(policy(model).permitted_attributes)
  end

  def model
    Organization
  end

  # prevent user to make organization belonging to not allowed organization
  def filter_parent_id
    return if current_user.admin_editor?
    id = params[model.name.underscore.to_sym][:parent_id].to_i
    return if current_user.allowed_organizations_ids.include?(id)
    params[model.name.underscore.to_sym][:parent_id] = nil
  end
end
