# frozen_string_literal: true

class RightsController < ApplicationController
  include Record

  def index
    authorize model
    @role = role
    if @role.id
      scope = model.where(role_id: @role.id)
      @records = records(scope)
      render 'index'
    else
      @records = records(model)
      render 'application/index'
    end
  end

  def new
    authorize model
    @record = model.new
    @role = role
    set_leveles_and_subject_types
  end

  def create
    authorize model
    @record = model.new(record_params)
    @role = role
    @record.save!
    redirect_to(
      session.delete(:edit_return_to),
      role_id: @role.id,
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    set_leveles_and_subject_types
    render :new
  end

  def edit
    @record = record
    authorize @record
    @role = role
    set_leveles_and_subject_types
  end

  def update
    @record = record
    authorize @record
    @role = role
    @record.update!(record_params)
    redirect_to(
      session.delete(:edit_return_to),
      role_id: role.id,
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    set_leveles_and_subject_types
    render :edit
  end

  def destroy
    @record = record
    authorize @record
    @role = role
    @record.destroy
    message = if @record.destroy
                {success: t('flashes.destroy', model: model.model_name.human)}
              # TODO show translated (human) record name in error
              else
                {danger: @record.errors.full_messages.join(', ')}
              end
    redirect_back(
      { fallback_location: polymorphic_url(@record.class),
        role_id: @role.id }
      .merge message
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

  def role
    role_id = if params[:role_id]
                params[:role_id]
              elsif params.dig(:q, :role_id_eq)
                params[:q][:role_id_eq]
              elsif params.dig(model.name.underscore.to_sym, :role_id)
                params[model.name.underscore.to_sym][:role_id]
              end
    Role.where(id: role_id).first || @record&.role || OpenStruct.new(id: nil)
  end

  def records_includes
    %i[role organization] # don`t inculde subjects here - not all subject is a ActiveRecord Models (for example - Chart)
  end

  def default_sort
    'level asc'
  end
end
