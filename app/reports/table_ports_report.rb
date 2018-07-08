# frozen_string_literal: true

class TablePortsReport < BaseReport
  include DateTimeHelper

  set_lang :ru
  set_report_name :table_ports
  set_human_name 'Открытые порты (таблица)'
  set_report_model 'ScanResult'
  set_required_params %i[]

  def report(r)
    r.page_size do
      width       16837 # sets the page width. units in twips.
      height      11905 # sets the page height. units in twips.
      orientation :landscape  # sets the printer orientation. accepts :portrait and :landscape.
    end
    if options[:organization_id].present?
      organization = OrganizationPolicy::Scope.new(current_user, Organization).resolve.where(id: options[:organization_id]).first
      r.p  "Справка по открытым портам хостов организации #{organization.name}", style: 'Header'
    else
      r.p  "Справка по открытым портам организаций", style: 'Header'
    end
    r.p  "(по состоянию на #{Date.current.strftime('%d.%m.%Y')})", style: 'Prim'

    scope = ScanResult
    if organization.present?
      scope = scope.joins('JOIN hosts h ON scan_results.ip <<= h.ip')
           .where('h.organization_id = ?', organization.id)
    end
    records = ScanResultsQuery.new(scope)
      .last_results
      .select('scan_results.*, scan_results.ip AS scan_results_ip, real_organizations.name AS real_organization_name, hosts.*')
      .joins('LEFT OUTER JOIN hosts ON hosts.ip = scan_results.ip')
      .joins('LEFT OUTER JOIN organizations real_organizations ON real_organizations.id = hosts.organization_id')
      .where(state: :open)
      .order('real_organization_name', 'scan_results_ip', 'scan_results.port')
    header = [[
      'Дата проверки',
      'Организация',
      'IP',
      'Порт',
      'Протокол',
      'Состояние',
      'Легальность',
      'Сервис',
      'ПО сервиса',
      'Дополнительно'
    ]]

    table = records.each_with_object(header) do |record, memo|
      row = []
      record = ScanResultDecorator.new(record)
      row << "#{show_date_time(record.job_start)}"
      row << "#{record.real_organization_name}"
      row << "#{record.scan_results_ip}"
      row << "#{record.port}"
      row << "#{record.protocol}"
      row << "#{record.show_state}"
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
  end
end
