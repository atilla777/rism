# frozen_string_literal: true
class ScanJobLogDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_state
    if finish.present?
      "#{I18n.t('labels.scan_job_logs.finished')}"
    else
      "#{I18n.t('labels.scan_job_logs.started')}"
    end
  end

  def show_worker_state
    return "#{I18n.t('labels.scan_job_logs.worker_was')}" if finish.present?
    if working?
      "#{I18n.t('labels.scan_job_logs.worker_work')}"
    else
      "#{I18n.t('labels.scan_job_logs.worker_lost')}"
    end
  end

  def show_distance
    finish_time = if finish.present?
                    finish
                  else
                    Time.now
                  end
    ((finish_time - start).round)/60
  end
end
