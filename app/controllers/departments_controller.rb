class DepartmentsController < ApplicationController
  include RecordOfOrganization

  def select
    authorize model
    @organization = organization
    @department = department
    if params[:user_ids]
      session[:selected_users] ||= []
      session[:selected_users] += params[:user_ids]
      session[:selected_users] = session[:selected_users].uniq
    end
    if params[:department_ids]
      session[:selected_departments] ||= []
      session[:selected_departments] += params[:department_ids]
      session[:selected_departments] = session[:selected_departments].uniq
    end

    redirect_back(fallback_location: root_path)
  end

  def reset
    authorize model
    @organization = organization
    @department = department
    session[:selected_departments] = []
    session[:selected_users] = []

    redirect_back(fallback_location: root_path)
  end

  def paste
    authorize model
    @organization = organization
    @department = department
    session[:selected_departments] ||= []
    session[:selected_users] ||= []
    session[:selected_users].each do | id |
      User.find(id.to_i)
          .update_attributes(department_id: @department.id)
    end
    session[:selected_departments].each do | id |
      department = Department.find(id.to_i)
      department.update_attributes(parent_id: @department.id) unless department.id == @department.id
    end
    session[:selected_departments] = []
    session[:selected_users] = []

    redirect_back(fallback_location: root_path)
  end

  def index
    authorize model
    @organization = organization
    @department = department
    scope = model.where(organization_id: @organization.id) if @organization&.id.present?
    if @department.id.present?
      scope = scope.where(parent_id: @department.id)
    elsif @organization.id
      scope = scope.where('departments.parent_id IS NULL')
    else
      scope = model
    end
    @q = scope.ransack(params[:q])

    @q.sorts = 'rank asc' if @q.sorts.empty?
    @records = @q.result
                 .includes(:organization)
                 .page(params[:page])
    if params[:organization_id].present?
      render 'index'
    else
      render 'application/index'
    end
  end

  def show
    @record = record
    authorize @record
    @organization = organization
    @department = department
  end

  def new
    authorize Department
    @record = Department.new
    @organization = organization
    @department = department
  end

  def create
    authorize Department
    @record = Department.new(record_params)
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
    @organization = organization
    @department = department
    authorize @record
  end

  def update
    @record = record
    @organization = organization
    @department = department
    authorize @record
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
    @record = model.find(params[:id])
    authorize @record
    @department = department
    @organization = organization
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
    elsif params[:q] && params[:q][:organization_id_eq].present?
      Organization.where(id: params[:q][:organization_id_eq]).first
    elsif params[:department] && params[:department][:organization_id]
      Organization.where(id: params[:department][:organization_id]).first
    else
      OpenStruct.new(id: nil)
    end
  end

  def department
    if params[:department_id].present?
      Department.where(id: params[:department_id]).first
    elsif params[:department].present? && params[:department][:parent_id].present?
      Department.where(id: params[:department][:parent_id]).first
    else
      OpenStruct.new(id: nil)
    end
  end

  def model
    Department
  end
end
