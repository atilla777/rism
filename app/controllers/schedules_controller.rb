# frozen_string_literal: true

class SchedulesController < ApplicationController
  include Record

  def show
    @job = params[:job_type].constantize.find(params[:job_id])
    #@organization = @job.organization
    @record = model.where(job_id: params[:job_id])
                   .where(job_type: params[:job_type])
                   .first_or_initialize

    authorize @record
  end

  def update
    @job = params[:job_type].constantize.find(params[:job_id])
    #@organization = @job.organization
    @record = model.where(job_id: params[:job_id])
                   .where(job_type: params[:job_type])
                   .first_or_initialize
    authorize @record
    @record.job_id = @job.id
    @record.job_type = @job.class
    update_minutes if params[:minute]
    update_hours if params[:hour]
    update_week_days if params[:week_day]
    update_month_days if params[:month_day]
    update_months if params[:month]
    @record.save
  end

  private

  def update_minutes
    if params[:destroy]
      @record.minutes = @record.minutes - [params[:minute].to_i]
    else
      @record.minutes = @record.minutes | [params[:minute]]
    end
    render 'renew_minutes'
  end

  def update_hours
    if params[:destroy]
      @record.hours = @record.hours - [params[:hour].to_i]
    else
      @record.hours = @record.hours | [params[:hour]]
    end
    render 'renew_hours'
  end

  def update_week_days
    if params[:destroy]
      @record.week_days = @record.week_days - [params[:week_day].to_i]
    else
      @record.week_days = @record.week_days | [params[:week_day]]
    end
    render 'renew_week_days'
  end

  def update_month_days
    if params[:destroy]
      @record.month_days = @record.month_days - [params[:month_day].to_i]
    else
      @record.month_days = @record.month_days | [params[:month_day]]
    end
    render 'renew_month_days'
  end

  def update_months
    if params[:destroy]
      @record.months = @record.months - [params[:month].to_i]
    else
      @record.months = @record.months | [params[:month]]
    end
    render 'renew_month'
  end

  def model
    Schedule
  end

#  def filter_for_organization
#    model.joins(:job)
#         .where(job: {organization_id: @organization.id})
#  end

  def default_sort
    'created_at desc'
  end

#  def records_includes
#    %i[organization job]
#  end
end
