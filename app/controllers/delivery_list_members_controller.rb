# frozen_string_literal: true

class DeliveryListMembersController < ApplicationController
  before_action :set_delivery_list, only: [:index, :create]

  include Record

  def index
    if params[:active_tab] == 'allowed_organizations'
      @records = organizations
      render 'organizations_index'
    else
      @records = delivery_list_members
    end
  end

  def create
    authorize DeliveryListMember
    organization = Organization.find(params[:organization_id])
    authorize organization
    authorize @delivery_list
    DeliveryListMember.create(
      delivery_list_id: @delivery_list.id,
      organization_id: organization.id,
    )
  end

  def destroy
    authorize DeliveryListMember
    delivery_list_member = DeliveryListMember.find(params[:id])
    @delivery_list = delivery_list_member.delivery_list
    authorize @delivery_list
    delivery_list_member.destroy
  end

  private

  def model
    DeliveryListMember
  end

  def set_delivery_list
    @delivery_list = DeliveryList.find(params[:delivery_list_id])
  end

  def organizations
    scope = policy_scope(Organization)
    @q = scope.ransack(params[:q])
    @q.sorts = default_sort if @q.sorts.empty?
    @q.result
      .includes(records_includes)
      .page(params[:page])
  end

  def delivery_list_members
    scope = policy_scope(@delivery_list.delivery_list_members)
    @q = scope.ransack(params[:q])
    @q.sorts = default_sort if @q.sorts.empty?
    @q.result
      .includes(records_includes)
      .page(params[:page])
  end
end
