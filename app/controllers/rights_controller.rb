# frozen_string_literal: true

class RightsController < ApplicationController
  include Record

  def index
    authorize model
    role_id = if params[:role_id]
                params[:role_id]
              else
                params[:q][:role_id_eq]
              end
    @role = Role.find(role_id)
    scope = model.where(role_id: @role.id)
    @records = records(scope)
  end

  def new
    authorize model
    @record = model.new
    @role = Role.find(params[:role_id])
    set_leveles_and_subject_types
  end

  def create
    authorize model
    @record = model.new(record_params)
    @role = Role.find(params[:right][:role_id])
    @record.save!
    redirect_to(
      rights_path(role_id: @role.id),
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::InvalidRecord
    set_leveles_and_subject_types
    render :new
  end

  def edit
    @record = record
    authorize @record
    @role = @record.role
    set_leveles_and_subject_types
  end

  def update
    @record = record
    authorize @record
    @record.update!(record_params)
    redirect_to(
      rights_path(role_id: @record.role.id),
      success: t('flashes.update', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    @role = @record.role
    set_leveles_and_subject_types
    render :edit
  end

  def destroy
    @record = record
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

  def set_leveles_and_subject_types
    @subject_types = model.subject_types
    @levels = model.levels
  end

  def default_includes
    %i[role organization]
  end

  def default_sort
    'level asc'
  end
end
