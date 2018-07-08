# frozen_string_literal: true

class CSVPortsReport < BaseReport
  include DateTimeHelper

  set_lang :ru
  set_report_name :csv_ports
  set_human_name 'Открытые порты (CSV)'
  set_report_model 'ScanResult'
  set_required_params %i[]

  def report(r)
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

     r.p "Дата сканирования; Организация; IP; Порт; Протокол; Состояние; Легальность; Сервис; ПО сервиса; Дополнительная информация"
    records.each do |record|
      record = ScanResultDecorator.new(record)
      r.p "#{show_date_time(record.job_start)}; #{record.real_organization_name}; #{record.scan_results_ip}; #{record.port}; #{record.protocol}; #{record.show_state}, #{record.show_current_legality}, #{record.service}; #{record.product_version}; #{record.product_extrainfo}"
    end
  end
end
