class EmailIndicators < BaseChart
  set_chart_name :email_indicators
  set_human_name 'Топ индикаторов - email'
  set_kind :pie_chart

  def chart
    scope = Pundit.policy_scope(current_user, Indicator)
    scope.where(content_format: 'email_adress').top(:content, 20)
  end
end
