# frozen_string_literal: true

class DeliverySubjectsController < ApplicationController
  include RecordOfOrganization
  include ReadableRecord

  before_action :set_deliverable_subject, only: [:list_subjects, :create]

  def list_subjects
  end

  def show
    @record = record
    authorize @record.class
    respond_to do |format|
      format.js  { render template: 'application/modal_show.js.erb' }
      format.html { render 'show_without_tabs' }
    end
  end

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

  def toggle_processed
    delivery_subject = record
    authorize delivery_subject.class
    delivery_subject.toggle(:processed)
    delivery_subject.processed_by_id = current_user.id
    delivery_subject.save
    @record = VulnerabilityDecorator.new(delivery_subject.reload)
    set_readable_log
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
    model.joins(:delivery_list)
         .merge(
           DeliveryList.joins(:organizations)
                       .where('delivery_recipients.organization_id =?', organization.id)
         )
  end

  def records_includes
    [:deliverable, :processor]
  end
end
