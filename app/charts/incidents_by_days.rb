class IncidentsByDays < BaseChart
  set_chart_name :incidents_by_days
  set_human_name 'Инциденты по дням'
  set_kind :line_chart

  def chart
    result = Incident.group_by_day(:created_at).count
    [{name: 'Количество', data: result}]
  end
end
