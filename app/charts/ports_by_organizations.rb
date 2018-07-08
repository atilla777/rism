class PortsByOrganizations < BaseChart
  set_chart_name :open_ports_by_organizations
  set_human_name 'Открытые порты по организациям (топ 10 организаций)'
  set_kind :column_chart

  def chart
    scope = ScanResult.where(state: :open)
    scope = ScanResultsQuery.new(scope)
                            .last_results
                            .includes(:organization)
                            .order('organizations.name')
    result = scope.top('organizations.name', 10)
    [{name: 'Количество', data: result}]
  end
end
