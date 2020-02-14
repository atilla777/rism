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

  # get organization to wich record belongs
  def organization
    id = if params[:organization_id]
           params[:organization_id]
         elsif params.dig(:q, :parent_id_eq)
           params[:q][:parent_id_eq]
         elsif params.dig(model.name.underscore.to_sym, :organization_id)
           params[model.name.underscore.to_sym][:organization_id]
         end
    Organization.where(id: id).first || @record&.organization || OpenStruct.new(id: nil)
  end

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
