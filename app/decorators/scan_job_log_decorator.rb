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
end
