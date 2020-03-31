# frozen_string_literal: true

class UsersController < ApplicationController
  include RecordOfOrganization

  autocomplete(:user, :name)

  # authorization for autocomplete
  def active_record_get_autocomplete_items(parameters)
    authorize model
    if current_user.admin_editor?
      super(parameters)
    else
      super(parameters).where(
        organization_id: current_user.allowed_organizations_ids
      )
    end
  end

  def generate_api_token
    @record = User.find(params[:id])
    authorize @record
    begin
      @record.api_token = SecureRandom.hex
    end while User.exists?(api_token: @record.api_token)
    @record.current_user = current_user
    @record.save
  end

  def index
    authorize model
    @role = role
    if params[:department_id].present?
      @department = Department.find(params[:department_id])
      scope = @department.users
      template = 'department_users'
    elsif @role.present?
      scope = @role.users
      template = 'role_index'
    else
      scope = User
      template = 'index'
    end
    @records = records(scope)
    render template
  end

  def new
    authorize model
    @record = model.new
    @organization = organization
    @department = department
  end

  def create
    authorize model
    @record = User.new(record_params)
    @record.current_user = current_user
    @organization = organization
    @department = department
    @record.save!
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization.id,
      department_id: @department.id,
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    @record = record
    authorize @record
    @organization = organization
    @department = department
  end

  def change_password
    @record = record
    authorize @record
    render '_password_form'
  end

  def update_password
    @record = record
    authorize @record
    @record.current_user = current_user
    if @record.update(record_params)
      message = if record_params[:password].blank?
                  {danger: t('flashes.password_not_update', model: model.model_name.human)}
                else
                  {success: t('flashes.password_update', model: model.model_name.human)}
                end
      redirect_to(
        @record,
        message
      )
    else
      render '_password_form'
    end
  end

  def update
    @record = record
    authorize @record
    @record.current_user = current_user
    @organization = organization
    @department = department
    @record.update!(record_params)
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization.id,
      department_id: @department.id,
      success: t('flashes.update', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @record = record
    authorize @record
    @organization = organization
    @department = department
    message = if @record.destroy
                {success: t('flashes.destroy', model: model.model_name.human)}
              else
                {danger: @record.errors.full_messages.join(', ')}
              end
    redirect_back(
      { fallback_location: polymorphic_url(@record.class),
      organization_id: @organization.id, department_id: @department.id }
      .merge message
    )
  end

  private

  # transmit @record to detect permited attributes
  def record_params
    params.require(model.name.underscore.to_sym)
          .permit(policy(model).permitted_attributes(@record))
  end

  # TODO: try to remove (it can be replaced by record_of_organization)
  def organization
    organization_id = if params[:organization_id]
                        params[:organization_id]
                      elsif params.dig(:q, :organization_id_eq)
                        params[:q][:organization_id_eq]
                      elsif params.dig(:user, :organization_id)
                        params[:user][:organization_id]
                      end
    Organization.where(id: organization_id).first || @record.organization
  end

  def department
    department_id = if params[:department_id]
                      params[:department_id]
                    elsif params.dig(:user, :department_id)
                      params[:user][:department_id]
                    elsif @record&.department
                      @record.department
                    end
    Department.where(id: department_id).first || OpenStruct.new(id: nil)
  end

  def role
    role_id = if params[:role_id]
                params[:role_id]
              elsif params.dig(:q, :role_id_eq)
                params[:q][:role_id_eq]
#              elsif params.dig(model.name.underscore.to_sym, :role_id)
#                params[model.name.underscore.to_sym][:role_id]
              end
    return nil unless role_id.present?
#    Role.where(id: role_id).first #|| @record&.role || OpenStruct.new(id: nil)
    Role.find(role_id)#|| @record&.role || OpenStruct.new(id: nil)
  end

  def model
    User
  end

  def default_sort
    params[:department_id].present? ? 'rank asc' : 'name'
  end

  def records_includes
    %i[organization department]
  end
end
