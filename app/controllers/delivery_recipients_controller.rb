# frozen_string_literal: true

class DeliveryRecipientsController < ApplicationController
  before_action :set_delivery_list, only: [:index, :create]
  before_action :set_name_cont, only: [:index, :create, :destroy]

  include Record

  def index
    if active_tab_allowed_organizations?
      @records = organizations
      render 'organizations_index'
    else
      @records = delivery_recipients
    end
  end

  def create
    authorize DeliveryRecipient
    organization = Organization.find(params[:organization_id])
    authorize organization
    authorize @delivery_list
    DeliveryRecipient.create(
      delivery_list_id: @delivery_list.id,
      organization_id: organization.id,
    )
    @records = organizations
  end

  def destroy
    authorize DeliveryRecipient
    delivery_recipient = DeliveryRecipient.find(params[:id])
    @delivery_list = delivery_recipient.delivery_list
    authorize @delivery_list
    delivery_recipient.destroy
    @records = delivery_recipients
  end

  private

  def model
    DeliveryRecipient
  end

  def set_delivery_list
    if params[:delivery_list_id]
      @delivery_list = DeliveryList.find(params[:delivery_list_id].to_i)
    else
      @delivery_list = DeliveryList.find(params[:q][:delivery_list_id_eq].to_i)
    end
  end

  def active_tab_allowed_organizations?
    return true if params[:active_tab] == 'allowed_organizations'
    return true if params.dig(:q, :active_tab_eq) == 'allowed_organizations'
  end

  def organizations
    assigned_organizations_ids = @delivery_list.organizations
      .pluck(:organization_id)
    scope = policy_scope(Organization)
    scope = scope.where.not(id: assigned_organizations_ids)
    @q = scope.ransack(params[:q])
    @q.sorts = default_sort if @q.sorts.empty?
    @q.result
      .includes(records_includes)
      .page(params[:page])
  end

  def delivery_recipients
    scope = policy_scope(@delivery_list.delivery_recipients)
    @q = scope.ransack(params[:q])
    @q.sorts = default_sort if @q.sorts.empty?
    @q.result
      .includes(records_includes)
      .page(params[:page])
  end

  def set_name_cont
    @name = params.dig('q', 'name_cont')
  end

  def records_includes
    [:organization]
  end
end
