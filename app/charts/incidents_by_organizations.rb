class IncidentsByOrganizations < BaseChart
  set_chart_name :incidents_by_organizations
  set_human_name 'Инциденты по организациям (топ 10 связанных с инцидентами)'
  set_kind :column_chart

  def chart
    #result = Incident.joins(:links).group('links.first_record_id').count.limit 2
    result = Incident.joins(:incident_organizations)
      .top('organizations.name', 10)
    [{name: 'Количество', data: result}]
  end
end
