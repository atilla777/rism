class IllegalPortsByOrganizations < BaseChart
  set_chart_name :illegal_ports_by_organizations
  set_human_name 'Нелегальные и неизвестные порты по организациям (топ 10 организаций)'
  set_kind :column_chart

  def chart
    result = ScanResultsQuery.new(ScanResult)
      .last_results
      .joins('LEFT OUTER JOIN hosts ON hosts.ip = scan_results.ip')
      .joins('LEFT OUTER JOIN organizations ON organizations.id = hosts.organization_id')
      .joins('LEFT OUTER JOIN host_services ON host_services.organization_id = hosts.organization_id AND host_services.port = scan_results.port AND host_services.host_id = hosts.id')
      .where(state: :open)
      .where('host_services.legality = 0 OR host_services.legality = 1')
      .top('organizations.name', 10)
    [{name: 'Количество', data: result}]
  end
end
