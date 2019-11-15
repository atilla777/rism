class VulnerabilitiesBulletinsByDays < BaseChart
  set_chart_name :vulnerabilities_bulletins_by_days
  set_human_name 'Сохранено бюллетеней в день (за месяц)'
  set_kind :line_chart

  def chart
    scope = Pundit.policy_scope(current_user, VulnerabilityBulletin)
    result = scope.group_by_day(
      'vulnerability_bulletins.created_at',
      range: 1.month.ago.midnight..Time.now
    ).count
    [{name: 'Количество', data: result}]
  end
end
