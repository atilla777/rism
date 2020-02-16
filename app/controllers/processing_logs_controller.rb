# frozen_string_literal: true

class ProcessingLogsController < ApplicationController
  include ReadableRecord

  before_action(
    :set_delivery_subject,
    only: [:toggle_processed]
  )

  def toggle_processed
    authorize @record
    processing_log = ProcessingLog.where(
      delivery_subject_id: @record.id,
      organization_id: organization.id
    ).first_or_initialize
    processing_log.processor = current_user
    processing_log.toggle(:processed)
    processing_log.save
    set_readable_log
  end

  private

  def organization
    Organization.find(params[:organization_id])
  end

  def set_delivery_subject
    @record = DeliverySubject.find(params[:delivery_subject_id])
  end
end
