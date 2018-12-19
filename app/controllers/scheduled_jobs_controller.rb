# frozen_string_literal: true

class ScheduledJobsController < ApplicationController

  def index
    authorize :scheduled_jobs
    @records = records.group_by { |job| job.queue }
  end

  def destroy
    if params[:name].present?
      authorize :scheduled_jobs, :destroy_all?
      destroy_queue(params[:name])
    else
      authorize :scheduled_jobs, :destroy?
      destroy_job(params[:jid])
    end
    redirect_to scheduled_jobs_path
  end

  private

  def destroy_job(jid)
    records.each do |j|
      j.delete if j.jid == jid
    end
  end

  def destroy_queue(name)
    Sidekiq::Queue.new(name).clear
  end

  private

  def records
    results = Sidekiq::Queue.all.each_with_object([]) do |queue, jobs|
      queue.each do |j|
        jobs << j
      end
    end
    ScheduledJobsPolicy::Scope.new(current_user, results).resolve
  end
end
