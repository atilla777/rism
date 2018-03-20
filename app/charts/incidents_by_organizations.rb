class IncidentsByOrganizations < BaseChart
  set_chart_name :incidents_by_organizations
  set_human_name 'Инциденты по организациям'
  set_kind :column_chart

  def chart
    Incident.joins(:links).group('links.first_record_id').count
  end
end
