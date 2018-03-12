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

  def index
    authorize model
    if params[:department_id].present?
      @department = Department.find(params[:department_id])
      scope = @department.users
      template = 'department_users'
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
    filter_organization_id
    # TODO: filter for active and password for admin and owner only
    @record = User.new(record_params)
    @organization = organization
    @department = department
    @record.save!
    redirect_to(
      session.delete(:return_to),
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

  def update
    @record = record
    authorize @record
    @organization = organization
    @department = department
    # TODO: filter for active and password for admin and owner only
    filter_organization_id
    @record.update!(record_params)
    redirect_to(
      session.delete(:return_to),
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

  def organization
    organization_id = if params[:organization_id]
                        params[:organization_id]
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

  def model
    User
  end

  def default_sort
    params[:department_id].present? ? 'rank asc' : 'name'
  end
end
