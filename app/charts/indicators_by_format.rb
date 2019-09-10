class IndicatorsByFormat < BaseChart
  set_chart_name :indicators_by_format
  set_human_name 'Индикаторы по формату'
  set_kind :bar_chart

  def chart
    sql = <<~SQL
      SELECT
      COUNT(*) count_all,
      content_format
      FROM indicators
      GROUP BY indicators.content_format
    SQL

    scope = Pundit.policy_scope(current_user, Indicator)
    scope.find_by_sql(sql).each_with_object({}) do
      |i, memo| memo[Indicator.human_enum_name(:content_format, i.content_format)] = i.count_all
    end
  end
end
