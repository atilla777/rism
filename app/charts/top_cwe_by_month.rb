class TopCweByMonth < BaseChart
  set_chart_name :top_cwe_by_month
  set_human_name 'CWE уязвимостей (топ 20 за месяц)'
  set_kind :pie_chart

  def chart
    scope = Pundit.policy_scope(current_user, Vulnerability)
    scope = scope.where(created_at: 1.month.ago.midnight..Time.now)
    result = scope.top('cwe', 20)
  end
end
