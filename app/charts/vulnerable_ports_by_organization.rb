class VulnerablePortsByOrganization < BaseChart
  set_chart_name :vulnerable_ports_by_organizations
  set_human_name 'Уязвимые сервисы по организациям (топ 10 организаций)'
  set_kind :bar_chart

  def chart
    result = ScanResultsQuery.new(ScanResult)
      .last_results
      .joins('LEFT OUTER JOIN hosts ON hosts.ip = scan_results.ip')
      .joins('LEFT OUTER JOIN organizations ON organizations.id = hosts.organization_id')
      .where(state: :open)
      .where('scan_results.vulners->0 IS NOT NULL')
      .top('organizations.name', 10)
    [{name: 'Количество', data: result}]
  end
end
