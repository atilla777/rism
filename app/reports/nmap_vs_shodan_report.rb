# frozen_string_literal: true

class NmapVsShodanReport < BaseReport
    Result = Struct.new(
#      'Result',
#      :job_start,
#      :finished,
      :organization_name,
      :ip,
      :port,
      :protocol,
      :vulns,
      :engines
#      :product_version,
#      :product_extrainfo
    )

  include DateTimeHelper

  set_lang :ru
  set_report_name :namp_vs_shodan
  set_human_name 'Открытые порты Nmap vs Shodan'
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

    records = records_request(scope)

    header = [[
#      'Дата проверки',
#      'Дата сканирования',
      'Организация',
      'IP',
      'Порт',
      'Протокол',
      'Уязвимости',
      'Сканер'
#      'Состояние',
#      'Легальность',
#      'Сервис',
#      'ПО сервиса',
#      'Дополнительно'
    ]]

    records = records.each_with_object([]){ |rc, memo| memo << collapse_record(rc) }
    # records = records.sort_by { |rc| rc.organization_name if rc.organization_name.to_s }


    table = records.each_with_object(header) do |record, memo|
      next if record.ip.blank?
      row = []
      record = ScanResultDecorator.new(record)
#      row << "#{show_date_time(record.job_start)}"
#      row << "#{show_date_time(record.finished)}"
      row << "#{record.organization_name}"
      row << "#{record.ip}"
      row << "#{record.port}"
      row << "#{record.protocol}"
      row << "#{record.show_vulns_names}" 
      row << "#{record.engines}"
#      row << "#{record.show_state}"
#      row << "#{record.show_current_legality}"
#      row << "#{record.service}"
#      row << "#{record.product_version}"
#      row << "#{record.product_extrainfo}"
      memo << row
    end
    r.p
    r.table(table, border_size: 4) do
      cell_style rows[0],    bold: true,   background: '3366cc', color: 'ffffff'
      cell_style cells,      size: 20, margins: { top: 100, bottom: 0, left: 100, right: 100 }
     end
  end

  private

  def collapse_record(temp_record)
    if temp_record['nmap_port'] == 0
      temp_record['nmap_organization_name'] = nil
      temp_record['nmap_ip'] = nil
      temp_record['nmap_port'] = nil
      temp_record['nmap_protocol'] = nil
    end
    if temp_record['shodan_port'] == 0
      temp_record['shodan_organization_name'] = nil
      temp_record['shodan_ip'] = nil
      temp_record['shodan_port'] = nil
      temp_record['shodan_protocol'] = nil
    end
    Result.new(
      temp_record['nmap_organization_name'] || temp_record['shodan_organization_name'],
      temp_record['nmap_ip'] || temp_record['shodan_ip'],
      temp_record['nmap_port'] || temp_record['shodan_port'],
      temp_record['nmap_protocol'] || temp_record['shodan_protocol'],
      temp_record['vulns'],
      temp_record['engines']
    )
  end

  def records_request(scope)
    ScanResultsQuery.new(scope).nmap_vs_shodan.to_hash
  end
end
