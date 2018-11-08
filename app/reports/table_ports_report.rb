# frozen_string_literal: true

class TablePortsReport < BaseReport
  require 'csv'
  include DateTimeHelper

  set_lang :ru
  set_report_name :table_ports
  set_human_name 'Открытые порты (таблица)'
  set_report_model 'ScanResult'
  set_required_params %i[]
  set_formats %i[docx csv]

  def docx(blank_document)
    r = blank_document
    r.page_size do
      width       16837 # sets the page width. units in twips.
      height      11905 # sets the page height. units in twips.
      orientation :landscape  # sets the printer orientation. accepts :portrait and :landscape.
    end
    if @organization.present?
      r.p  "Справка по открытым портам хостов организации #{@organization.name}", style: 'Header'
    else
      r.p  "Справка по открытым портам организаций", style: 'Header'
    end
    r.p  "(по состоянию на #{Date.current.strftime('%d.%m.%Y')})", style: 'Prim'


    header = [[
      'Дата проверки',
      'Дата сканирования',
      'Организация',
      'Сканер',
      'IP',
      'Порт',
      'Протокол',
      'Состояние',
      'Уязвимости',
      'Легальность',
      'Сервис',
      'ПО сервиса',
      'Дополнительно'
    ]]

    table = @records.each_with_object(header) do |record, memo|
      row = []
      record = ScanResultDecorator.new(record)
      row << "#{show_date_time(record.job_start)}"
      row << "#{show_date_time(record.finished)}"
      row << "#{record.real_organization_name}"
      row << "#{record.scan_engine}"
      row << "#{record.scan_results_ip}"
      row << "#{record.port}"
      row << "#{record.protocol}"
      row << "#{record.show_state}"
      row << "#{record.show_vulners_names}"
      row << "#{record.show_current_legality}"
      row << "#{record.service}"
      row << "#{record.product_version}"
      row << "#{record.product_extrainfo}"
      memo << row
    end
    r.p
    r.table(table, border_size: 4) do
      cell_style rows[0],    bold: true,   background: '3366cc', color: 'ffffff'
      cell_style cells,      size: 20, margins: { top: 100, bottom: 0, left: 100, right: 100 }
     end

    header = [[
      'Сервис',
      'Уязвимость',
      'CVSS',
      'Описание уязвимости',
      'Ссылки на описание уязвимости',
    ]]

    table = @records.each_with_object(header) do |record, memo|
      next if record.vulners.empty?
      record.vulners.sort_by{ |v| v.fetch('cvss', '0').to_i }.reverse.each do |v|
        row = []
        record = ScanResultDecorator.new(record)
        service = []
        service << "#{record.scan_results_ip}"
        service << "#{record.real_organization_name}"
        service << "#{record.scan_engine}"
        service << "#{record.port}"
        service << "#{record.protocol}"
        service << "#{show_date_time(record.job_start)}"
        service << "#{show_date_time(record.finished)}"
        row << service.join(', ')
        row << v.fetch('cve', '')
        cvss = v.fetch('cvss', 0)
        row << (cvss.to_f == 0 ? '' : cvss)
        row << "#{v.fetch('summary', '')}\n"
        links = []
        v.fetch('references', []).each do |link|
          links << "#{link}"
        end
        row << links.join(', ')
        memo << row
      end
    end

    r.p
    r.p  "Уязвимости", style: 'Header'
    r.p

    r.table(table, border_size: 4) do
      cell_style rows[0],    bold: true,   background: '3366cc', color: 'ffffff'
      cell_style cells,      size: 20, margins: { top: 100, bottom: 0, left: 100, right: 100 }
     end
  end

  def csv(blank_document)
    r = blank_document

    header = [
      'Дата проверки',
      'Дата сканирования',
      'Организация',
      'Сканер',
      'IP',
      'Порт',
      'Протокол',
      'Состояние',
      'Уязвимости',
      'Легальность',
      'Сервис',
      'ПО сервиса',
      'Дополнительно'
    ]

    r << header

    @records.each do |record|
      row = []
      record = ScanResultDecorator.new(record)
      row << "#{show_date_time(record.job_start)}"
      row << "#{show_date_time(record.finished)}"
      row << "#{record.real_organization_name}"
      row << "#{record.scan_engine}"
      row << "#{record.scan_results_ip}"
      row << "#{record.port}"
      row << "#{record.protocol}"
      row << "#{record.show_state}"
      row << "#{record.show_vulners_names}"
      row << "#{record.show_current_legality}"
      row << "#{record.service}"
      row << "#{record.product_version}"
      row << "#{record.product_extrainfo}"
      r << row
     end

    header = [
      'Сервис',
      'Уязвимость',
      'CVSS',
      'Описание уязвимости',
      'Ссылки на описание уязвимости',
    ]
    r << header

    @records.each do |record|
      next if record.vulners.empty?
      record.vulners.sort_by{ |v| v.fetch('cvss', '0').to_i }.reverse.each do |v|
        row = []
        record = ScanResultDecorator.new(record)
        service = []
        service << "#{record.scan_results_ip}"
        service << "#{record.real_organization_name}"
        service << "#{record.scan_engine}"
        service << "#{record.port}"
        service << "#{record.protocol}"
        service << "#{show_date_time(record.job_start)}"
        service << "#{show_date_time(record.finished)}"
        row << service.join(', ')
        row << v.fetch('cve', '')
        cvss = v.fetch('cvss', 0)
        row << (cvss.to_f == 0 ? '' : cvss)
        row << "#{v.fetch('summary', '')}\n"
        links = []
        v.fetch('references', []).each do |link|
          links << "#{link}"
        end
        row << links.join(', ')
        r << row
      end
    end
  end

  private

  def get_records(options, organization)
    scope = ScanResult
    if organization.present?
      scope = scope.joins('JOIN hosts h ON scan_results.ip <<= h.ip')
           .where('h.organization_id = ?', organization.id)
    end
    ScanResultsQuery.new(scope)
      .last_results
      .select('scan_results.*, scan_results.ip AS scan_results_ip, real_organizations.name AS real_organization_name, hosts.*')
      .joins('LEFT OUTER JOIN hosts ON hosts.ip = scan_results.ip')
      .joins('LEFT OUTER JOIN organizations real_organizations ON real_organizations.id = hosts.organization_id')
      .where(state: :open)
      .order('real_organization_name', 'scan_results_ip', 'scan_results.port')
  end
end
