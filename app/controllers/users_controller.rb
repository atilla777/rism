class UsersController < ApplicationController
  include RecordOfOrganization

  def index
    authorize model
    if params[:department_id].present?
      @department = Department.find(params[:department_id])
      scope = @department.users
      r = 'department_users'
    else
      scope = User
      r = 'index'
    end
    scope = policy_scope(scope)
    @q = scope.ransack(params[:q])
    @q.sorts = 'rank asc' if @q.sorts.empty?
    @records = @q.result
                 .includes(:organization)
                 .page(params[:page])
    render r
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
    @organization = organization
    @department = department
    if @record.save
      redirect_to(session.delete(:return_to),
                   organization_id: @organization.id,
                   department_id: @department.id,
                   success: t('flashes.create',
                              model: model.model_name.human))
    else
      render :new
    end
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
    if @record.update(record_params)
      redirect_to(session.delete(:return_to),
                   organization_id: @organization.id,
                   department_id: @department.id,
                   success: t('flashes.update',
                              model: model.model_name.human))
    else
      render :edit
    end
  end

  def destroy
    @record = record
    authorize @record
    @organization = organization
    @department = department
    @record.destroy
    redirect_back(fallback_location: polymorphic_url(@record.class),
                  organization_id: @organization.id,
                  department_id: @department.id,
                  success: t('flashes.destroy',
                              model: model.model_name.human))
  end

  private

  def organization
    if params[:organization_id].present?
      Organization.where(id: params[:organization_id]).first
    elsif params[:user] && params[:user][:organization_id]
      Organization.where(id: params[:user][:organization_id]).first
    else
      @record.organization
    end
  end

  def department
    if params[:department_id].present?
      Department.where(id: params[:department_id]).first
    elsif params[:user].present? && params[:user][:department_id].present?
      Department.where(id: params[:user][:department_id]).first
    elsif @record.present? && @record.department.present?
      @record.department
    else
      OpenStruct.new(id: nil)
    end
  end

  def model
    User
  end
end
