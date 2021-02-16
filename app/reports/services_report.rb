# frozen_string_literal: true

class ServicesReport < BaseReport
  include DateTimeHelper

  set_lang :ru
  set_report_name :services
  set_human_name 'Сервисы'
  set_report_model 'HostService'
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
      r.p  "Справка по сетевым сервисам организации #{@organization.name}", style: 'Header'
    else
      r.p  "Справка по сетевым сервисам организаций", style: 'Header'
    end
    r.p  "(по состоянию на #{Date.current.strftime('%d.%m.%Y')})", style: 'Prim'

    header = [[
      'Организация',
      'IP-адрес',
      'Порт',
      'Протокол',
      'Состояние',
      'Легальность',
      'Уязвимость',
      'Описание уязвимости',
      'Описание',
      'Дата изменения статуса обработки',
      'Реквизиты состояния обработки'
    ]]

    table = @records.each_with_object(header) do |record, memo|
      row = []
      row << "#{record.organization.name}"
      row << "#{record.host.ip}"
      row << "#{record.port}"
      row << "#{record.protocol}"
      row << "#{record.show_state}"
      row << "#{ScanResultDecorator.new(record).show_legality}"
      row << "#{HostServiceDecorator.new(record).show_vulnerable}"
      row << "#{record.vuln_description}"
      row << "#{record.description}"
      row << "#{record.host_service_status_changed_at}"
      row << "#{record.host_service_status_prop}"
      memo << row
    end
    r.p
    r.table(table, border_size: 4) do
      cell_style rows[0],    bold: true,   background: '3366cc', color: 'ffffff'
      cell_style cells,      size: 20, margins: { top: 100, bottom: 0, left: 100, right: 100 }
     end
  end

  def csv(blank_document)
    r = blank_document

    header = [
      'Организация',
      'IP-адрес',
      'Порт',
      'Протокол',
      'Состояние',
      'Легальность',
      'Уязвимость',
      'Описание уязвимости',
      'Описание',
      'Дата изменения статуса обработки',
      'Реквизиты состояния обработки'
    ]
    r << header

    @records.each do |record|
      row = []
      row << "#{record.organization.name}"
      row << "#{record.host.ip}"
      row << "#{record.port}"
      row << "#{record.protocol}"
      row << "#{record.show_state}"
      row << "#{ScanResultDecorator.new(record).show_legality}"
      row << "#{HostServiceDecorator.new(record).show_vulnerable}"
      row << "#{record.vuln_description}"
      row << "#{record.description}"
      row << "#{record.host_service_status_changed_at}"
      row << "#{record.host_service_status_prop}"
      r << row
    end
  end

  private

  def get_records(options, organization)
    scope = HostService
    if organization.present?
      scope = scope.where(organization_id: organization.id)
    end
    scope = scope.select('host_services.*')
         .select('scan_results.state')
         .joins(join_host)
         .joins(join_scan_result)
    result = Pundit.policy_scope(current_user, scope)
                   .joins(:organization)
                   .order('organizations.name')
                   .order('hosts.ip')
                   .order(:port)
                   .order(:protocol)
    HostServiceDecorator.wrap(result)
  end

  def join_host
    <<~SQL
      LEFT JOIN hosts
        ON host_services.host_id = hosts.id
    SQL
  end

  def join_scan_result
    <<~SQL
      LEFT JOIN scan_results
      ON scan_results.ip = hosts.ip
      AND scan_results.port = host_services.port
      AND scan_results.protocol = host_services.protocol
      AND scan_results.id IN
      (SELECT
       scan_results.id
       FROM scan_results
        INNER JOIN (
          SELECT
            scan_results.ip,
            MAX(scan_results.job_start)
            AS max_time
          FROM scan_results
          GROUP BY scan_results.ip
        )m
        ON scan_results.ip = m.ip
        AND scan_results.job_start = m.max_time
      )
    SQL
  end
end
