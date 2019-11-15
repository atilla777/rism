class TopVulnerabilitiesProcessors < BaseChart
  set_chart_name :top_vulnerabilities_processors
  set_human_name 'Обработчики уязвимостей (топ 10)'
  set_kind :column_chart

  def chart
    scope = Pundit.policy_scope(current_user, Vulnerability)
    result = scope.joins(:processor)
                  .top('users.name', 10)
    [{name: 'Количество', data: result}]
  end
end
