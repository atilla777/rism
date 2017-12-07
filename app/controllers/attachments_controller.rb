class AttachmentsController < ApplicationController
  include DefaultMethods

  def create
    authorize get_model
    params[:attachment][:organization_id] = current_user.organization.id
    @attachment = Attachment.new(record_params)
    record = get_record
    if @attachment.save
      redirect_to polymorphic_path(record),
                                   success: t('flashes.create', model: Attachment.model_name.human)
    else
      redirect_to polymorphic_path(record),
                                   danger: t('flashes.not_create', model: Attachment.model_name.human)
    end
  end

  private
  def get_model
    Attachment
  end

  def get_record
    model = params[:attachment][:attachment_link][:record_type].camelize.constantize
    model.find(params[:attachment][:attachment_link][:record_id])
  end
end
