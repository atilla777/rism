# frozen_string_literal: true

class CustomReportsResultsController < ApplicationController
  include RecordOfOrganization

  before_action :set_custom_report

  def download
    authorize record
    send_file(
      record.result_path,
      disposition: 'attachment',
      x_sendfile: true
    )
  end

  def index
    authorize model
    @organization = organization
    @records = records(filter_for_organization)
  end

  def new
    @record = model.new
    authorize @record.class
    @record.custom_report_id = params[:custom_report_id]
    render template: 'application/modal_form.js.erb'
  end

  def create
    @record = model.new(record_params)
    authorize @record.class
    authorize @custom_report
    @organization = organization
    @record.current_user = current_user
    @record.custom_report = @custom_report
    @record.save!
    CustomReportJob.perform_later(
      nil, # Custom report ID - it will be not nil when run from schedule
      'custom_report', # Queue
      @record.id # Custom report result ID - it will be nil when run from schedule
    )
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization.id,
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    render :new
#    redirect_to(
#      session.delete(:edit_return_to),
#      organization_id: @organization.id,
#      danger: t('flashes.not_create', model: model.model_name.human)
#    )
  end

  private

  def set_custom_report
    if params[:custom_report_id].present?
      @custom_report = CustomReport.find(params[:custom_report_id])
    elsif params.dig(:custom_reports_result, :custom_report_id)
      @custom_report = CustomReport.find(
        params[:custom_reports_result][:custom_report_id]
      )
    else
      @custom_report = record.custom_report
    end
  end

  def model
    CustomReportsResult
  end

  def default_sort
    'created_at desc'
  end

#  def filter_for_organization
#    model.joins('JOIN custom_reports ON custom_reports.id = custom_reports_results.custom_report_id')
#         .where('custom_reports.organization_id = ?', @organization.id)
#  end
  def filter_for_organization
    model
  end

  def records_includes
    %i[custom_report organization]
  end

  def record_params
    params.require(model.name.underscore.to_sym)
          .permit(
            policy(model).permitted_attributes(
              CustomReportJob::Query.new(@custom_report.statement).variables_arr
            )
          )
  end
end
