class IncidentsByRegistrator < BaseChart
  set_chart_name :incidents_by_registrator
  set_human_name 'Инциденты по работникам (топ 10 регистраторов)'
  set_kind :bar_chart

  def chart
    result = Incident.joins(:user).top('users.name', 10)
    [{name: 'Количество', data: result}]
  end
end
