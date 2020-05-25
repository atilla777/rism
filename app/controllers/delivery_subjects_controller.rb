# frozen_string_literal: true

class DeliverySubjectsController < ApplicationController
  include RecordOfOrganization
  include ReadableRecord

  before_action :set_deliverable_subject, only: [:list_subjects, :create]

  def list_subjects; end

#  def notify
#    authorize DeliverySubject
#    DeliverySubjectMailer.with(
#      deliverable_type: params[:deliverable_type],
#      deliverable_id: params[:deliverable_id],
#      comments: params[:comments].first,
#      current_user: current_user
#    ).notify.deliver_later
#    @message = 'Ok'
#  end

  # TODO: rename @record to @delivarable
  def create
    delivery_list = DeliveryList.find(params[:delivery_list_id])
    authorize delivery_list
    authorize @record
    authorize DeliverySubject
    DeliverySubject.create(
      delivery_list_id: delivery_list.id,
      deliverable_type: @record.class.model_name,
      deliverable_id: @record.id
    )
    render 'renew_list_subjects'
  end

  def destroy
    authorize DeliverySubject
    delivery_subject = DeliverySubject.find(params[:id])
    authorize delivery_subject.delivery_list
    @record = delivery_subject.deliverable
    authorize @record
    delivery_subject.destroy
    render 'renew_list_subjects'
  end

  private

  def model
    DeliverySubject
  end

  def default_sort
    'created_at desc'
  end

  def set_deliverable_subject
    @record = params[:deliverable_type].constantize
      .find(params[:deliverable_id])
  end

  def organization
    id = if params[:organization_id]
           params[:organization_id]
         elsif params.dig(:q, :organization_id_eq)
           params[:q][:organization_id_eq]
         elsif params.dig(model.name.underscore.to_sym, :organization_id)
           params[model.name.underscore.to_sym][:organization_id]
         end
    if id
      Organization.where(id: id).first || @record&.organization || OpenStruct.new(id: nil)
    else
      @record.delivery_list.organization
    end
  end

  def filter_for_organization
    model.joins(:delivery_recipients)
         .where('delivery_recipients.recipientable_type = ?', 'Organization')
         .where('delivery_recipients.recipientable_id = ?', organization.id)
  end

  def records_includes
    [:deliverable]
  end
end
