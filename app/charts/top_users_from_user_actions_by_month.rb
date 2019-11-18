class TopUsersFromUserActionsByMonth < BaseChart
  set_chart_name :top_users_from_user_actions_by_month
  set_human_name 'Пользователи (топ 20 за месяц)'
  set_kind :pie_chart

  def chart
    scope = Pundit.policy_scope(current_user, UserAction)
    scope = scope.where(created_at: 1.month.ago.midnight..Time.now)
                 .joins(:user)
    result = scope.top('users.name', 10)
  end
end
