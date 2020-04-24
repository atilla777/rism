# frozen_string_literal: true

class SchedulesController < ApplicationController
  include Record

  def show
    @job = params[:job_type].constantize.find(params[:job_id])
    @record = model.where(job_id: params[:job_id])
                   .where(job_type: params[:job_type])
                   .first_or_initialize

    authorize @record
    @partial = case params[:job_type]
               when 'ScanJob'
                 'scan_jobs/show_tabs'
               when 'CustomReport'
                 'custom_reports/show_tabs'
               end
  end

  def update
    @job = params[:job_type].constantize.find(params[:job_id])
    @record = model.where(job_id: params[:job_id])
                   .where(job_type: params[:job_type])
                   .first_or_initialize
    authorize @record
    @record.current_user = current_user
    @record.job_id = @job.id
    @record.job_type = @job.class
    update_minutes if params[:minute]
    update_hours if params[:hour]
    update_week_days if params[:week_day]
    update_month_days if params[:month_day]
    update_months if params[:month]
    update_crontab_line if params[:crontab_line]
    # TODO: add errors show for handling in Schedule.save and Sidekiq::Cron.save
    @record.save!
  rescue ActiveRecord::RecordInvalid
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_erros.log"))
    logger.tagged("SCHEDULE: #{@record&.job&.name}") do
      logger.error("schedule can`t be saved - #{@record.errors.full_messages}")
    end
  end

  private

  def update_crontab_line
    @record.crontab_line = params[:crontab_line]
    render 'renew_crontab_line'
  end

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

  def default_sort
    'created_at desc'
  end
end
