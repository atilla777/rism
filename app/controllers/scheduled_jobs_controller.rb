# frozen_string_literal: true

class ScheduledJobsController < ApplicationController

  def index
    authorize :scheduled_jobs
    @records = Sidekiq::Queue.all
  end

  def destroy
    authorize :scheduled_jobs
    if params[:name].present?
      destroy_queue(params[:name])
    else
      destroy_job(params[:jid])
    end
    redirect_to scheduled_jobs_path
  end

  private

  def destroy_job(jid)
    Sidekiq::Queue.all.each do |queue|
      queue.each do |j|
        j.delete if j.jid == jid
      end
    end
  end

  def destroy_queue(name)
    Sidekiq::Queue.new(name).clear
  end
end
