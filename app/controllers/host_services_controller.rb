# frozen_string_literal: true

class HostServicesController < ApplicationController
  include RecordOfOrganization

  def autocomplete_service_name
    authorize model
    scope = if current_user.admin_editor?
              HostService
            elsif current_user.can_read_model_index? Organization
              HostService
            else
              HostService.where(
                organization_id: current_user.allowed_organizations_ids
              )
            end

    term = params[:term]
    records = scope.select(:id, :name, :port, :protocol)
                   .where(
                     'name ILIKE ? OR port::text LIKE ?',
                     "%#{term}%", "#{term}%"
                   )
                   .order(:port)
    result = records.map do |record|
               {
                 id: record.id,
                 port: record.port,
                 protocol: record.port,
                 value: record.show_full_name
               }
             end
    render json: result
  end

  private

  def model
    HostService
  end

  def default_sort
    'port desc'
  end

  def records_includes
    %i[organization host]
  end
end
