class IncidentsByNameChart < BaseChart
  set_chart_name :incidents_by_name_chart
  set_human_name 'Инциденты по названиям'
  set_kind :pie_chart

  def chart
    Incident.group(:name).count
  end
end
