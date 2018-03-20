class IncidentsBySeveryties < BaseChart
  set_chart_name :incidents_by_severyties
  set_human_name 'Инциденты по важности'
  set_kind :pie_chart

  def chart
    sql = <<~SQL
      SELECT
      COUNT(*) count_all,
      CASE incidents.severity
      WHEN 0
      THEN 'Обычный'
      WHEN 1
      THEN 'Важный'
      END
      AS incidents_severity
      FROM
      incidents
      GROUP BY incidents.severity
    SQL

    Incident.find_by_sql(sql).each_with_object({}) do
      |i, memo| memo[i.incidents_severity] = i.count_all
    end
  end
end
