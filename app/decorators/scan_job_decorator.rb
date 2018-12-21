# frozen_string_literal: true
class ScanJobDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_working_count
    working = scan_job_logs.where('finish IS NULL')
    return '' if working.blank?
    working.count
  end

  def show_planned_count
    result = Sidekiq::Queue.all.sum(0) do |queue, memo|
      queue.sum do |job_from_queue|
        scan_job_id(job_from_queue) == id ? 1 : 0
      end
    end
    result == 0 ? '' : result
  end

  def show_separator
    '/' if show_planned_count.present?
  end

  private

  def scan_job_id(job_from_queue)
    job_from_queue.args[0]['arguments'][0]
  end
end
