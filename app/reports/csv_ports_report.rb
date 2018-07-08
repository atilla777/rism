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
      scope = scope.joins('JOIN hosts ON scan_results.ip <<= hosts.ip')
           .where('hosts.organization_id = ?', organization.id)
    end
    scope = scope.where(state: :open)
    records = ScanResultsQuery.new(scope)
                            .last_results
                            .includes(:organization)
                            .order('scan_jobs.organization_id', :ip, :port)
     r.p "Дата сканирования; Организация; IP; Порт; Протокол; Состояние; Сервис; ПО сервиса; Дополнительная информация"
    records.each do |record|
      r.p "#{show_date_time(record.job_start)}; #{record.organization.name}; #{record.ip}; #{record.port}; #{record.protocol}; #{ScanResultDecorator.new(record).show_state}, #{record.service}; #{record.product_version}; #{record.product_extrainfo}"
    end
  end
end
