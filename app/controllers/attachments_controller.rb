# frozen_string_literal: true

class AttachmentsController < ApplicationController
  include SharedMethods

  def create
    authorize Attachment
    params[:attachment][:organization_id] = current_user.organization.id
    attachment = Attachment.new(attachment_params)
    attachment.skip_child_validation = true
    attachment.save!
#    message = { success: t('flashes.create',
#                model: Attachment.model_name.human) }
    redirect_back fallback_location: root_path
  rescue ActiveRecord::RecordInvalid
#    message = { danger: t('flashes.not_create',
#                model: Attachment.model_name.human) }
    redirect_back fallback_location: root_path
  end

  def download
    attachment = Attachment.find(params[:id])
    authorize attachment
    send_file attachment.document
                        .path, disposition: 'attachment', x_sendfile: true
  end

  private

  def attachment_params
    params.require(:attachment)
          .permit(policy(Attachment).permitted_attributes)
  end
end
