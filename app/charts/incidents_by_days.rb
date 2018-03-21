class IncidentsByDays < BaseChart
  set_chart_name :incidents_by_days
  set_human_name 'Инциденты по дням (за месяц)'
  set_kind :line_chart

  def chart
    result = Incident.group_by_day(:created_at, range: 1.month.ago.midnight..Time.now).count
    [{name: 'Количество', data: result}]
  end
end
