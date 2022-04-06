# frozen_string_literal: true

class TasksController < ApplicationController
  include RecordOfOrganization
  include ReadableRecord

  def autocomplete_task_name
    authorize model
    scope = if current_user.admin_editor?
              Task
            elsif current_user.can_read_model_index? Organization
              Task
            else
              Task.where(
                id: current_user.allowed_organizations_ids('Task')
              )
            end

    term = params[:term]
    records = scope.select(:id, :name)
                       .where('name ILIKE ? OR id::text LIKE ?', "%#{term}%", "#{term}%")
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

  def search
    index
    @scope = params.dig(:q, :scope_eq) || params.dig(:scope)
  end

  def index
    authorize model
    @organization = organization
    if params[:organization_id].present? || params.dig(:q, :organization_id_eq)
      index_for_organization
    else
      index_for_all_investigations
    end
  end

  def index_for_all_investigations
    @records = records(model)
    render 'index_for_all_tasks'
  end

  def index_for_organization
    @records = records(filter_for_organization)
  end

  private

  def model
    Task
  end

  def default_sort
    'rank asc'
  end

  def records_includes
    %i[user parent organization task_status task_priority]
  end
end