# frozen_string_literal: true

class OrganizationsController < ApplicationController
  include RecordOfOrganization

  def autocomplete_organization_name
    authorize model
    scope = if current_user.admin_editor?
              Organization
            elsif current_user.can_read_model_index? Organization
              Organization
            else
              Organization.where(
                id: current_user.allowed_organizations_ids('Organization')
              )
            end

    term = params[:term]
    records = scope.select(:id, :name)
                       .where('name ILIKE ? OR id::text LIKE ?', "%#{term}%", "#{term}%")
                       .order(:id)
    result = records.map do |record|
               {
                 id: record.id,
                 name: record.name,
                 :value => record.name
               }
             end
    render json: result
  end

  private

  def model
    Organization
  end

  def filter_for_organization
    model.where(parent_id: @organization.id)
  end

  def records_includes
    %i[parent organization_kind]
  end
end
