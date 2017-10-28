class RightsController < ApplicationController
  include DefaultActions

  autocomplete :organization, :name, full: true

  def index
    authorize Right
    if params[:role_id]
      @role = Role.find(params[:role_id])
    else
      @role = Role.find(params[:q][:role_id_eq])
    end
    @q = Right.where(role_id: @role.id)
                   .ransack(params[:q])
    @records = @q.result
                 .includes(:role)
                 .page(params[:page])
  end

  def new
    authorize Right
    @record = Right.new
    @role = Role.find(params[:role_id])
    @subject_types = Right.subject_types
    @levels = Right.levels
  end

  def create
    authorize Right
    puts "!!!!!!#{record_params}"
    @record = Right.new(record_params)
    @role = Role.find(params[:right][:role_id])
    if @record.save
      redirect_to rights_path(role_id: @role.id), success: t('flashes.create',
                                               model: get_model.model_name.human)
    else
      @subject_types = Right.subject_types
      @levels = Right.levels
      render :new
    end
  end

  def destroy
    @record = get_model.find(params[:id])
    authorize @record
    @record.destroy
    redirect_to polymorphic_url(@record.class, role_id: @record.role.id),
      success: t('flashes.destroy', model: get_model.model_name.human)
  end

  private
  def get_model
    Right
  end

  def permit_attributes
    %i[organization_id level role_id subject_id subject_type]
  end
end
