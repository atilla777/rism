class UsersController < ApplicationController
  include DefaultActions
  include Organizatable

  before_action :set_previous_page, only: [:new, :edit]

  def index
    authorize get_model
    if params[:department_id].present?
      @department = Department.find(params[:department_id])
      scope = @department.users
      r = 'department_users'
    else
      scope = User
      r = 'index'
    end
    @q = scope.ransack(params[:q])
    @records = @q.result
                 .includes(:organization)
                 .page(params[:page])
    render r
  end

  def new
    authorize get_model
    @record = get_model.new
    @organization = get_organization
    @department = get_department
  end

  def create
    authorize get_model
    @record = User.new(record_params)
    @organization = get_organization
    @department = get_department
    if @record.save
      redirect_to(session.delete(:return_to),
                   organization_id: @organization.id,
                   parent_id: @department.id,
                   success: t('flashes.create',
                              model: get_model.model_name.human))
#      if params[:user][:department_id].present?
#        redirect_to departments_path(organization_id: @organization.id, parent_id: @department.id), success: t('flashes.create',
#                                     model: get_model.model_name.human)
#      else
#        redirect_to users_path, success: t('flashes.create',
#                                           model: get_model.model_name.human)
#      end
    else
      render :new
    end
  end

  def edit
    @record = get_record
    authorize @record
    @organization = get_organization
    @department = get_department
  end

  def update
    @record = get_record
    authorize @record
    @organization = get_organization
    @department = get_department
    if @record.update(record_params)
      redirect_to(session.delete(:return_to),
                   organization_id: @organization.id,
                   parent_id: @department.id,
                   success: t('flashes.create',
                              model: get_model.model_name.human))
#      redirect_to @record, success: t('flashes.update',
#        model: get_model.model_name.human)
    else
      render :edit
    end
  end

  private
  def get_organization
    if params[:organization_id].present?
      Organization.where(id: params[:organization_id]).first
    #elsif params[:q] && params[:q][:organization_id_eq].present?
    #  Organization.where(id: params[:q][:organization_id_eq]).first
    elsif params[:user] && params[:user][:organization_id]
      Organization.where(id: params[:user][:organization_id]).first
    else
      @record.organization
    end
  end

  def get_department
    if params[:department_id].present?
      Department.where(id: params[:department_id]).first
    elsif params[:user].present? && params[:user][:department_id].present?
      Department.where(id: params[:user][:department_id]).first
    elsif params[:q] && params[:q][:parent_id_eq].present?
      Organization.where(id: params[:q][:parent_id_eq]).first
    elsif @record.present? && @record.department.present?
      @record.department
    else
      OpenStruct.new(id: nil)
    end
  end

  def set_previous_page
    session[:return_to] = request.referer
  end

  def get_model
    User
  end
end
