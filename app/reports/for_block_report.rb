# frozen_string_literal: true

class ForBlockReport < BaseReport
  set_lang :ru
  set_report_name :for_block
  set_human_name "Индикаторы (IoC) для блокировки (последние сутки)"
  set_report_model 'Indicator'
  set_required_params []
  set_formats %i[txt]

  def txt(blank_document)
    @file_name = "#{Time.now.utc} #{@human_name}.txt"
    r = blank_document
    @records.each do |record|
      r << "#{record}\n"
    end
  end

  private

  def get_records(options, _organization)
    now = Time.now
    Indicator.where(updated_at: ((now - 24.hours)..now))
      .where(trust_level: 'high')
      .where(purpose: 'for_prevent')
      .group(:content, :content_format)
      .order(:content_format)
      .pluck(:content)
  end
end
