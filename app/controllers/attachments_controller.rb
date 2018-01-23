# frozen_string_literal: true

class AttachmentsController < ApplicationController
  include SharedMethods

  def create
    authorize Attachment
    params[:attachment][:organization_id] = current_user.organization.id
    @attachment = Attachment.new(attachment_params)
    attachment_link = new_attachment_link
    begin
      Attachment.transaction do
        @attachment.save!
        attachment_link.attachment_id = @attachment.id
        attachment_link.save!
      end
    rescue
      message = { danger: t('flashes.not_create',
                            model: Attachment.model_name.human) }
    else
      message = { success: t('flashes.create',
                             model: Attachment.model_name.human) }
    ensure
      redirect_to polymorphic_path(attachment_link.record), message
    end
  end

  def download
    attachment = Attachment.find(params[:id])
    authorize attachment
    send_file attachment.document
                        .path, disposition: 'attachment', x_sendfile: true
  end

  private

  def new_attachment_link
    AttachmentLink.new(
      attachment_id: @attachment.id,
      record_type: params[:attachment][:attachment_link][:record_type],
      record_id: params[:attachment][:attachment_link][:record_id]
    )
  end

#  def record
#    record_model = AttachmentLink.linkable_models.find do | model_constant |
#      model_constant.name == params[:attachment][:attachment_link][:record_type]
#                        .classify
#    end
#    record_model.find(params[:attachment][:attachment_link][:record_id])
#  end

  def attachment_params
    params.require(:attachment)
          .permit(
            :name,
            :document,
            :organization_id,
            attachment_link_attributes: [:id,
                                         :record_type,
                                         :record_id,
                                         :attachment_id]
          )
  end
end
