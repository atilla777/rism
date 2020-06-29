# frozen_string_literal: true

class HostsController < ApplicationController
  include RecordOfOrganization
  include ReadableRecord

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

  def search
    index
    @scope = params.dig(:q, :scope_eq) || params.dig(:scope)
  end

  def create
    @record = model.new(record_params)
    authorize @record.class
    @organization = organization
    if @record.to_hosts == '1'
      result = SaveNetworkAsHostsService.call(
        @record.ip,
        @record.name,
        @record.description,
        @organization.id,
        current_user
      )
      @record.errors.add(:base, 'Error - try save without checkbox')
      raise ActiveRecord::RecordInvalid unless result
    else
      @record.current_user = current_user
      @record.save!
      add_from_template
    end
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization.id,
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    @template_id = params[:template_id]
    render :new
  end

  def new_import
    authorize Host
    @messages = {}
  end

  def create_import
    authorize Host
    file = params[:file]
    @organization = Organization.find( params[:organization_id])
    @messages = ImportHostsService2.call(file, @organization.id, current_user)
    render :new_import
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
