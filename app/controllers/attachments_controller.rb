class AttachmentsController < ApplicationController
  #include Organizatable

  def create
    authorize Attachment
    params[:attachment][:organization_id] = current_user.organization.id
    params[:current_user] = current_user
    @attachment = Attachment.new(attachment_params)
    @attachment.document = params[:attachment][:document]
    @attachment.save!

    redirect_to polymorphic_path(@attachment.record),
                                 success: t('flashes.create', model: Attachment.model_name.human)
  end

  private
  def get_model
    Attachment
  end

  def attachment_params
    params.require(get_model.name.underscore.to_sym)
          .permit(policy(get_model).permitted_attributes)
  end
end
