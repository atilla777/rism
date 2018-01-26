# frozen_string_literal: true

class AttachmentLinksController < ApplicationController
  def destroy
    record = AttachmentLink.where(
      attachment_id: params[:attachment_id],
      record_type: params[:record_type],
      record_id: params[:record_id]
    ).first
    authorize record
    record.destroy
    redirect_back(
      fallback_location: root_path,
      success: t('flashes.destroy', model: AttachmentLink.model_name.human)
    )
  end
end
