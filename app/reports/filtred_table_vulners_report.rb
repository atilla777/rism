# frozen_string_literal: true

class FiltredTableVulnersReport < BaseReport
  include DateTimeHelper

  set_lang :ru
  set_report_name :filtred_table_vulners
  set_human_name 'Результаты поиска по полям'
  set_report_model 'Vulnerability'
  set_required_params %i[q]
  set_formats %i[csv]

  def csv(blank_document)
    r = blank_document

    header = [
      '№',
      'CVE ID',
      'CWE ID',
      'Источник',
      'Дата публикации NVD',
      'Дата обновления NVD',
      'Дата сохранения в базе',
      'Дата обновления в базе',
      'Производители',
      'Продукты',
      'Версии',
      'Критичность',
      'Базовое значение CVSS',
      'Вектор CVSS',
      'Вектор атаки',
      'Описание источника',
      'Описание',
      'Ссылки источника',
      'Ссылки',
      'Рекомендации',
    ]
    r. << header

    @records.each_with_index do |record, index|
      row = []
      record = VulnerabilityDecorator.new(record)

      row << index + 1
      row << record.codename
      row << record.show_cwe
      row << record.show_feed
      row << show_date_time(record.published)
      row << show_date_time(record.modified)
      row << show_date_time(record.created_at)
      row << show_date_time(record.updated_at)
      row << record.show_vendors_text
      row << record.show_products_text
      row << record.show_versions_string(limit: 10, separator: "\n")
      row << record.show_criticality
      row << record.show_cvss
      row << record.show_cvss_vector
      row << record.show_cvss_av
      row << record.show_description_string
      row << record.custom_description
      row << record.show_references_string(limit: 10, separator: "\n")
      row << record.custom_references
      row << record.custom_recomendation

      r << row
    end
  end

  private

  def get_records(options, organization)
    scope = Vulnerability
    if options[:q].present?
      records_request(
        ransack_filter_and_sort(scope, options)
      )
    else
      records_request(scope)
    end
  end

  def get_records(options, organization)
    Vulnerability.actual_and_relevant
  end

  def records_request(scope)
    scope.actual_and_relevant
  end

  def ransack_filter_and_sort(scope, options)
    q = scope.ransack(options[:q])
    q.result
      .limit(500)
  end
end
