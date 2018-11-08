# frozen_string_literal: true

class ShodanTablePortsReport < TablePortsReport
  set_lang :ru
  set_report_name :shodan_table_ports
  set_human_name 'Shodan открытые порты'
  set_report_model 'ScanResult'
  set_required_params %i[]
  set_formats %i[docx csv]

  private

  def records_request(scope)
    ScanResultsQuery.new(scope)
      .last_shodan_results
      .select('scan_results.*, scan_results.ip AS scan_results_ip, real_organizations.name AS real_organization_name, hosts.*')
      .joins('LEFT OUTER JOIN hosts ON hosts.ip = scan_results.ip')
      .joins('LEFT OUTER JOIN organizations real_organizations ON real_organizations.id = hosts.organization_id')
      .where(state: :open)
      .order('real_organization_name', 'scan_results_ip', 'scan_results.port')
  end
end
