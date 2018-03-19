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
                                            .except(
                                              'id',
                                              'organization_id',
                                              'user_id',
                                              'created_at',
                                              'updated_at'
                                            )
    @original_record_id = params[:original_record_id]
  end

  def create
    authorize model
    @record = model.new(record_params)
    original_model = @record.record_type.constantize
    original_record = original_model.find(params[:original_record_id])
    @record.record_content = params[:record_template][:record_content]
    @record.record_tags = original_record.tags.pluck(:id)
#    @record.record_links = original_record.links.pluck(:id)
#    @record.record_attachment_links = original_record.attachment_links.pluck(:id)
    @record.save!
    redirect_to(
      polymorphic_path(@record),
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    @original_record_id = params[:original_record_id]
    render :new
  end

  def update
    @record = record
    authorize @record
    @record.record_content = params[:record_template][:record_content]
    @record.record_tags = params[:record_template][:record_tags]
    @record.update!(record_params)
    redirect_to(
      @record,
      success: t('flashes.update', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  private

  def model
    RecordTemplate
  end
end