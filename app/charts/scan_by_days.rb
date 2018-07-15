class ScanByDays < BaseChart
  set_chart_name :scan_by_days
  set_human_name 'Сканирований по дням (за месяц)'
  set_kind :line_chart

  def chart
    result = ScanResult.group_by_day(:job_start, range: 1.month.ago.midnight..Time.now).count
    [{name: 'Количество', data: result}]
  end
end
