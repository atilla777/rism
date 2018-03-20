class IncidentsByRegistrator < BaseChart
  set_chart_name :incidents_by_registrator
  set_human_name 'Инциденты по работникам (регистраторам)'
  set_kind :bar_chart

  def chart
    result = Incident.joins(:user).group('users.name').count
    [{name: 'Количество', data: result}]
  end
end
