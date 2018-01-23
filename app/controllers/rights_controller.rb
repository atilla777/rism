class RightsController < ApplicationController
  include Record

  def index
    authorize model
    if params[:role_id]
      @role = Role.find(params[:role_id])
    else
      @role = Role.find(params[:q][:role_id_eq])
    end
    @q = model.where(role_id: @role.id)
                   .ransack(params[:q])
    @records = @q.result
                 .includes(:role, :organization)
                 .page(params[:page])
  end

  def new
    authorize model
    @record = model.new
    @role = Role.find(params[:role_id])
    @subject_types = model.subject_types
    @levels = model.levels
  end

  def create
    authorize model
    @record = model.new(record_params)
    @role = Role.find(params[:right][:role_id])
    if @record.save
      redirect_to(
        rights_path(role_id: @role.id),
        success: t('flashes.create', model: model.model_name.human)
      )
    else
      @subject_types = model.subject_types
      @levels = model.levels
      render :new
    end
  end

  def destroy
    @record = model.find(params[:id])
    authorize @record
    @record.destroy
    redirect_to(
      polymorphic_url(@record.class, role_id: @record.role.id),
      success: t('flashes.destroy', model: model.model_name.human)
    )
  end

  private

  def model
    Right
  end
end
