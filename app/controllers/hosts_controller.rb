# frozen_string_literal: true

class HostsController < ApplicationController
  include RecordOfOrganization

  def autocomplete_host_name
    authorize model
    scope = if current_user.admin_editor?
              Host
            elsif current_user.can_read_model_index? Organization
              Host
            else
              Host.where(
                organization_id: current_user.allowed_organizations_ids
              )
            end

    term = params[:term]
    records = scope.select(:id, :name, :ip)
                       .where('name ILIKE ? OR ip::text LIKE ?', "%#{term}%", "#{term}%")
                       .order(:id)
    result = records.map do |record|
               {
                 id: record.id,
                 name: record.name,
                 ip: record.ip,
                 value: record.show_full_name
               }
             end
    render json: result
  end

  private

  def model
    Host
  end

  def default_sort
    'ip desc'
  end

  def records_includes
    %i[organization]
  end

  def preset_record
    return if params[:ip].blank?
    @record.ip = params[:ip]
  end

  def record_decorator(record)
    HostDecorator.new(record)
  end
end
