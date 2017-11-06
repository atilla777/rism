class DepartmentsController < ApplicationController
  include DefaultActions
  include Organizatable
  #before_action :get_parent, only: [:index, :new, :create]

  def index
    authorize Department
    @organization = get_organization
    @parent = get_parent
    scope = Department.where(organization_id: @organization.id)
    if @parent.id.present?
      scope = scope.where(parent_id: @parent.id)
    else
      scope = scope.where('departments.parent_id IS NULL')
    end
    @q = scope.ransack(params[:q])
    @records = @q.result
                 .includes(:organization)
                 .page(params[:page])
  end

  def show
    @record = get_record
    authorize @record
    @organization = get_organization
    @parent = get_parent
  end

  def new
    authorize Department
    @record = Department.new
    @organization = get_organization
    @parent = get_parent
  end

  def create
    authorize Department
    @record = Department.new(record_params)
    @organization = get_organization
    @parent = get_parent
    if @record.save
      redirect_to departments_path(organization_id: @organization.id, parent_id: @parent.id), success: t('flashes.create',
                                               model: get_model.model_name.human)
    else
      render :new
    end
  end

  def edit
    @record = get_record
    @organization = get_organization
    @parent = get_parent
    authorize @record
  end

  def update
    @record = get_record
    @organization = get_organization
    @parent = get_parent
    authorize @record
    if @record.update(record_params)
      redirect_to @record, success: t('flashes.update',
        model: get_model.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @record = get_model.find(params[:id])
    authorize @record
    @record.destroy
    redirect_to polymorphic_url(@record.class, organization_id: @record.organization.id, parent_id: @record.parent_id),
      success: t('flashes.destroy', model: get_model.model_name.human)
  end

  private
  def get_organization
    if params[:organization_id].present?
      Organization.where(id: params[:organization_id]).first
    elsif params[:q] && params[:q][:organization_id_eq].present?
      Organization.where(id: params[:q][:organization_id_eq]).first
    elsif params[:department] && params[:department][:organization_id]
      Organization.where(id: params[:department][:organization_id]).first
    else
      @record.organization
    end
  end

  def get_parent
    if params[:parent_id].present?
      Department.where(id: params[:parent_id]).first
    elsif params[:department].present? && params[:department][:parent_id].present?
      Department.where(id: params[:department][:parent_id]).first
    elsif params[:q] && params[:q][:parent_id_eq].present?
      Organization.where(id: params[:q][:parent_id_eq]).first
    elsif @record.present? && @record.parent_id.present?
      @record.parent
    else
      OpenStruct.new(id: nil)
    end
  end

  def get_model
    Department
  end
end
