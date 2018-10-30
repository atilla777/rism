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
end
