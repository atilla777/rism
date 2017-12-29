class AttachmentsController < ApplicationController
  include DefaultMethods

  def create
    authorize get_model
    params[:attachment][:organization_id] = current_user.organization.id
    @attachment = Attachment.new(record_params)
    record = get_record
    if @attachment.save
      a_l = AttachmentLink.new(attachment_id: @attachment.id,
                            record_type: params[:attachment][:attachment_link][:record_type],
                            record_id: params[:attachment][:attachment_link][:record_id])
      a_l.save
      redirect_to polymorphic_path(record),
                                   success: t('flashes.create', model: Attachment.model_name.human)
    else
      redirect_to polymorphic_path(record),
                                   danger: t('flashes.not_create', model: Attachment.model_name.human)
    end
  end

  def download
    record = get_model.find(params[:id])
    authorize record
    send_file record.document.path, disposition: 'attachment', x_sendfile: true
  end

  private
  def get_model
    Attachment
  end

  def get_record
    model = AttachmentLink.linkable_models.find do | model_constant |
      model_constant.name == params[:attachment][:attachment_link][:record_type]
                        .classify
    end
    model.find(params[:attachment][:attachment_link][:record_id])
  end

  def record_params
    params.require(get_model.name.underscore.to_sym)
          .permit(:name, :document, :organization_id,
                  attachment_link_attributes: [:id, :record_type, :record_id, :attachment_id])
          #.merge current_user: current_user
  end
end
