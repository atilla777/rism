class ActualAndRelevantVulnerabilitiesByDays < BaseChart
  set_chart_name :actual_and_relevant_vulnerabilities_by_days
  set_human_name 'Актуальные и релевантные уязвимости по дням (за месяц)'
  set_kind :line_chart

  def chart
    scope = Pundit.policy_scope(current_user, Vulnerability)
    scope = scope.where(
      custom_actuality: 'actual',
      custom_relevance: 'relevant'
    )
    result = scope.group_by_day(
      'vulnerabilities.created_at',
      range: 1.month.ago.midnight..Time.now
    ).count
    [{name: 'Количество', data: result}]
  end
end
