class TopCveScoreByMonth < BaseChart
  set_chart_name :top_cve_score_by_month
  set_human_name 'Базовые метрики CVSS v3 (топ 20 за месяц)'
  set_kind :pie_chart

  def chart
    scope = Pundit.policy_scope(current_user, Vulnerability)
    scope = scope.where(created_at: 1.month.ago.midnight..Time.now)
    result = scope.top(:cvss3, 20)
  end
end
