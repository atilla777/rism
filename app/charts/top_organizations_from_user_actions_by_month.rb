class TopOrganizationsFromUserActionsByMonth < BaseChart
  set_chart_name :top_organizations_from_user_actions_by_month
  set_human_name 'Организации (топ 20 за месяц)'
  set_kind :pie_chart

  def chart
    scope = Pundit.policy_scope(current_user, UserAction)
    scope = scope.where(created_at: 1.month.ago.midnight..Time.now)
                 .joins(:organization)
    result = scope.top('organizations.name', 20)
  end
end
