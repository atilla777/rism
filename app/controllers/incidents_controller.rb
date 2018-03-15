# frozen_string_literal: true

class IncidentsController < ApplicationController
  include Record

  before_action :set_time, only: [:create, :update]
  before_action :set_organization_id, only: [:new, :create]

  def index
    authorize model
    @organization = organization
    if @organization.present?
      @records = records(filter_for_organization)
      render 'index'
    else
      @records = records(model)
      render 'application/index'
    end
  end

  private

  def model
    Incident
  end

  # get organization to wich record belongs
  def organization
    return unless params[:organization_id]
    Organization.where(id: params[:organization_id]).first
  end

  # filter used in index pages wich is a part of organizaion show page
  # (such index shows only records that belongs to organization)
  def filter_for_organization
    @organization.me_linked_incidents.group(:id)
  end

  def default_sort
    'created_at desc'
  end

  def set_time
    %w[discovered started finished].each do |field|
    hours = params[:incident]["#{field}_at(4i)"]
    minutes = params[:incident]["#{field}_at(5i)"]
      if hours.present? && minutes.present?
        params[:incident]["#{field}_time"] = '1'
      else
        params[:incident]["#{field}_time"] = '0'
      end
    end
  end

  def set_organization_id
    return if params[:organization_id].blank?
    @organization_id = params[:organization_id]
  end
end
