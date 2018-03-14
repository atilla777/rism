# frozen_string_literal: true

class RecordTemplatesController < ApplicationController
  include Record

  def new
    authorize model
    @record = model.new
    @record.record_type = params[:original_record_type]
    original_model = @record.record_type.constantize
    original_record = original_model.find(params[:original_record_id])
    @record.record_content = original_record.attributes
    @record.record_tags = original_record.tags.pluck(:id)
    @original_record_id = params[:original_record_id]
  end

  def create
    authorize model
    @record = model.new(record_params)
    original_model = @record.record_type.constantize
    original_record = original_model.find(params[:original_record_id])
    @record.record_content = original_record.attributes
    @record.record_tags = original_record.tags.pluck(:id)
    @record.save!
    redirect_to(
      polymorphic_path(@record),
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    @original_record_id = params[:original_record_id]
    render :new
  end

  private

  def model
    RecordTemplate
  end
end
