# frozen_string_literal: true

class ProcessingLogsController < ApplicationController
  include ReadableRecord

  before_action(
    :set_processable,
    only: [:toggle_processed]
  )

  def toggle_processed
    authorize @record.deliverable
    authorize ProcessingLog
    processing_log = ProcessingLog.where(
      processable: @record,
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

  def set_processable
    processasble_model = params[:processable_type].constantize
    @record = processasble_model.find(
      params[:processasble_id]
    )
  end
end
