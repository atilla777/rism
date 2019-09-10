class IndicatorsByDays < BaseChart
  set_chart_name :indicators_by_days
  set_human_name 'Индикаторы по дням (за месяц)'
  set_kind :line_chart

  def chart
    scope = Pundit.policy_scope(current_user, Indicator)
    result = scope.group_by_day('indicators.created_at', range: 1.month.ago.midnight..Time.now).count
    [{name: 'Количество', data: result}]
  end
end
