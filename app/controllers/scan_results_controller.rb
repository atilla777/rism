# frozen_string_literal: true

class ScanResultsController < ApplicationController
  include RecordOfOrganization

  def index
    authorize_model
    if @organization.id
      @records = records(filter_for_organization)
    else
      @records = records(model)
    end
    select_render
  end

  def open_ports
    authorize_model
    if @organization.id
      @records = open_ports_records(filter_for_organization)
    else
      @records = open_ports_records(model)
    end
    select_render
  end

  def new_ports
    authorize_model
    select_render
  end

  private

  def authorize_model
    authorize model
    @organization = organization
  end

  def select_render
    if @organization.id
      render 'organization_index'
    else
      render 'index'
    end
  end

  def open_ports_records(scope)
    scope = policy_scope(scope)
    scope = scope.where(state: :open)
    scope = scope.joins(<<~SQL
                         INNER JOIN (
                           SELECT
                             scan_results.scan_job_id,
                             MAX(scan_results.job_start)
                             AS max_time
                           FROM scan_results
                           GROUP BY scan_results.scan_job_id
                         )m
                         ON scan_results.scan_job_id = m.scan_job_id
                         AND scan_results.job_start = m.max_time
                       SQL
                      )
    @q = scope.ransack(params[:q])
    @q.sorts = default_sort if @q.sorts.empty?
    @q.result
      .group(group_field)
      .includes(records_includes)
      .page(params[:page])
  end

  def model
    ScanResult
  end

  def default_sort
    'finished desc'
  end

  def records_includes
    %i[organization scan_job]
  end

  def filter_for_organization
    model.joins('JOIN hosts ON scan_results.ip <<= hosts.ip')
         .where('hosts.organization_id = ?', @organization.id)
  end
end
