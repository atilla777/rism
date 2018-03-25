# frozen_string_literal: true

class DepartmentsController < ApplicationController
  include RecordOfOrganization

  def autocomplete_department_id
    authorize model
    if current_user.admin_editor?
      scope = Department
    else
      scope = Department.where(
        organization_id: current_user.allowed_organizations_ids
      )
    end

    term = params[:term]
    departments = scope.select(:id, :name, :organization_id)
                       .where('id::text LIKE ?', "#{term}%")
                       .order(:id)
    result = departments.map do |department|
               {
                 id: department.id,
                 name: department.name,
                 organization_id: department.organization_id,
                 :value => department.show_full_name
               }
             end
    render json: result
  end

  def select
    authorize model
    @organization = organization
    @department = department
    set_selected_users
    set_selected_departments
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
    paste_selected_users
    paste_selected_departments
    redirect_back(fallback_location: root_path)
  end

  def index
    authorize model
    @organization = organization
    @department = department
    scope = if @department.id
              filter_for_organization.where(parent_id: @department.id)
            elsif @organization.id
              filter_for_organization.where('departments.parent_id IS NULL')
            else
              model
            end
    @records = records(scope)
    @organization.id ? render('index') : render('application/index')
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

  def update
    @record = record
    authorize @record
    @organization = organization
    @department = department
    @record.update!(record_params)
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization.id,
      department_id: @department.id, success: t(
        'flashes.update', model: model.model_name.human
      )
    )
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @record = model.find(params[:id])
    authorize @record
    @department = department
    @organization = organization
    @record.destroy
    redirect_back(
      fallback_location: polymorphic_url(@record.class),
      organization_id: @organization.id,
      department_id: @department.id,
      success: t('flashes.destroy', model: model.model_name.human)
    )
  end

  private

  def set_selected_users
    return unless params[:user_ids]
    session[:selected_users] ||= []
    session[:selected_users] += params[:user_ids]
    session[:selected_users] = session[:selected_users].uniq
  end

  def set_selected_departments
    return unless params[:department_ids]
    session[:selected_departments] ||= []
    session[:selected_departments] += params[:department_ids]
    session[:selected_departments] = session[:selected_departments].uniq
  end

  def paste_selected_users
    return if session[:selected_users].blank?
    session[:selected_users].each do |id|
      User.find(id.to_i)
          .update_attributes(department_id: @department.id)
    end
    session[:selected_users] = []
  end

  def paste_selected_departments
    return if session[:selected_departments].blank?
    session[:selected_departments].each do |id|
      department = Department.find(id.to_i)
      unless department.id == @department.id
        department.update_attributes(parent_id: @department.id)
      end
    end
    session[:selected_departments] = []
  end

  def department
    id = if params[:department_id]
           params[:department_id]
         elsif params.dig(:department, :parent_id)
           params[:department][:parent_id]
         end
    model.where(id: id).first || OpenStruct.new(id: nil)
  end

  def model
    Department
  end

  def default_sort
    'rank asc'
  end

  def records_includes
    return %i[organization] if params[:organization_id].blank?
    return %i[organization] unless current_user.admin_editor_reader?
  end
end
