# frozen_string_literal: true

class IncidentsController < ApplicationController
  include RecordOfOrganization

  before_action :set_time, only: [:create, :update]

  private

  def model
    Incident
  end

  # filter used in index pages wich is a part of organizaion show page
  # (such index shows only records that belongs to organization)
  def filter_for_organization
    @organization.me_linked_incidents.group(:id)
  end

  def default_sort
    'created_at desc'
  end

  def records_includes
    # exclude unused :organizations includes
    # when user is global admin, editor or reader
    # ( user can access to all organizations)
    [:user, :incident_organizations, [tags: :tag_kind]].tap do |associations|
      associations << :organization unless current_user.admin_editor_reader?
    end
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
end
