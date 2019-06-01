# frozen_string_literal: true

class UriForBlockReport < BaseReport
  set_lang :ru
  set_report_name :uri_for_block
  set_human_name "URI (IoC) для блокировки (последние сутки)"
  set_report_model 'Indicator'
  set_required_params []
  set_formats %i[txt]

  def txt(blank_document)
    @file_name = "#{Time.now.utc} #{@human_name}.txt"
    r = blank_document
    @records.each do |record|
      r << "#{record.content}\n"
    end
  end

  private

  def get_records(options, _organization)
    now = Time.now
    Indicator.where(
      purpose: 'for_prevent',
      trust_level: 'high',
      content_format: 'uri',
      updated_at: ((now - 24.hours)..now)
    )
  end
end
