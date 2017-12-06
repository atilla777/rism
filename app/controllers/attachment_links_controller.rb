class AttachmentLinksController < ApplicationController
#  def create
#    authorize AttachmentLink
#    @record = AttachmentLink.new(record_params)
#    if @record.save
#      redirect_to polymorphic_path(@record), success: t('flashes.create',
#                                                        model: get_model.model_name.human)
#    else
#      render :new
#    end
#  end

  private
  def record_params
    params.require(:attachment_link)
          .permit(policy(AttachmentLink).permitted_attributes)
  end
end
