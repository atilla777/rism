# frozen_string_literal: true

class IncidentsController < ApplicationController
  include RecordOfOrganization

  before_action :set_time, only: [:create, :update]

  def autocomplete_incident_name
    authorize model
    scope = if current_user.admin_editor?
              Incident
            elsif current_user.can_read_model_index? Organization
              Incident
            else
              Incident.where(
                organization_id: current_user.allowed_organizations_ids
              )
            end

    term = params[:term]
    records = scope.select(:id, :name, :created_at)
                       .where('name ILIKE ? OR id::text LIKE ?', "%#{term}%", "#{term}%")
                       .order(:id)
    result = IncidentDecorator.wrap(records).map do |record|
               {
                 id: record.id,
                 name: record.name,
                 value: record.show_full_name
               }
             end
    render json: result
  end

  def search
    authorize model
    @organization = organization
    if @organization.id
      @records = records(filter_for_organization)
      render 'index'
    else
      @records = records(model)
      render 'application/index'
    end
  end

  def autocomplete_incident_id
    authorize model
    scope = if current_user.admin_editor?
              model
            else
              model.where(
                organization_id: current_user.allowed_organizations_ids
              )
            end

    term = params[:term]
    records = scope.select(:id, :name)
                       .where('id::text LIKE ?', "#{term}%")
                       .order(:id)
    result = records.map do |record|
               {
                 id: record.id,
                 name: record.name,
                 :value => record.name
               }
             end
    render json: result
  end

  private

  def model
    Incident
  end

  def records(scope)
    scope = policy_scope(scope)
    @q = scope.ransack(params[:q])
    @q.sorts = default_sort if @q.sorts.empty?
    @q.result(distinct: true)
      .joins(:user) # For line below
      .select('incidents.*, users.name AS user_name') # Postrges dont allow use DISTINCT with ORDER BY by field that not in SELECT
      .preload(records_includes) # Explicitly preload records used in index
      .page(params[:page])
  end

# where(tag_kinds: {record_type: 'Incident'}) # Filter only incident specific tags
#  def tag_kind_join_sql
#    <<~SQL
#      LEFT OUTER JOIN tag_members
#      ON tag_members.record_id = incidents.id
#      AND tag_members.record_type = 'Incident'
#      LEFT OUTER JOIN tags
#      ON tags.id = tag_members.tag_id
#      LEFT OUTER JOIN tag_kinds
#      ON tag_kinds.id = tags.tag_kind_id
#      AND tag_kinds.record_type = 'Incident'
#    SQL
#  end

# filter used in index pages wich is a part of organizaion show page
# (such index shows only records that belongs to organization)
#  def filter_for_organization
#    @organization.me_linked_incidents.group(:id)
#  end

  def default_sort
    'created_at desc'
  end

  def records_includes
    # exclude unused :organizations includes
    # when user is global admin, editor or reader
    # ( user can access to all organizations)
    # TODO: resolve Bullet N+1 alerts
    [:user, :incident_organizations, incident_tags: :tag_kind]
#    [:user, :incident_organizations, incident_tags: :tag_kind].tap do |associations|
#      associations << :organization unless current_user.admin_editor_reader?
#    end
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
