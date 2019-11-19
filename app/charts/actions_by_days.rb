class ActionsByDays < BaseChart
  set_chart_name :actions_by_days
  set_human_name 'Действий в день (за месяц)'
  set_kind :line_chart

  def chart
    scope = Pundit.policy_scope(current_user, UserAction)
    result = scope.group_by_day('user_actions.created_at', range: 1.month.ago.midnight..Time.now).count
    [{name: 'Количество', data: result}]
  end
end
