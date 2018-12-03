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
      current_state
    end
  end

  def working?
    Sidekiq::Workers.new.find {|_,_, work| work['payload']['jid'] == jid}
  end

  private

  def current_state
    if working?
      "#{I18n.t('labels.scan_job_logs.started')}"
    else
      "#{I18n.t('labels.scan_job_logs.lost')}"
    end
  end
end
