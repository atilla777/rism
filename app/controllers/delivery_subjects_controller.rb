# frozen_string_literal: true

class DeliverySubjectsController < ApplicationController
  before_action :set_deliverable_subject, only: [:index, :create]

  include Record
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
  end

  def destroy
    authorize DeliverySubject
    delivery_subject = DeliverySubject.find(params[:id])
    authorize delivery_subject.delivery_list
    @record = delivery_subject.deliverable
    authorize @record
    delivery_subject.destroy
  end

  private

  def model
    DeliverySubject
  end

  def set_deliverable_subject
    @record = params[:deliverable_type].constantize
      .find(params[:deliverable_id])
  end
end
