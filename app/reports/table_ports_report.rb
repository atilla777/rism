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
      scope = scope.joins('JOIN hosts ON scan_results.ip <<= hosts.ip')
           .where('hosts.organization_id = ?', organization.id)
    end
    scope = scope.where(state: :open)
    records = ScanResultsQuery.new(scope)
                            .last_results
                            .includes(:organization)
                            .order(:ip)
    header = [[
      'Дата проверки',
      'Организация',
      'IP',
      'Порт',
      'Протокол',
      'Состояние',
      'Сервис',
      'ПО сервиса',
      'Дополнительно'
    ]]

    table = records.each_with_object(header) do |record, memo|
      row = []
      row << "#{show_date_time(record.job_start)}"
      row << "#{record.organization.name}"
      row << "#{record.ip}"
      row << "#{record.port}"
      row << "#{record.protocol}"
      row << "#{ScanResultDecorator.new(record).show_state}"
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
