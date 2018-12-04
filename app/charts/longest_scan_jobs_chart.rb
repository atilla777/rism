class LongestScanJobsChart < BaseChart
  set_chart_name :longest_scan_jobs
  set_human_name 'Длительность работ по сканированию за месяц (топ 5)'
  set_kind :column_chart

  def chart
    result = ScanJobLog.where('finish IS NOT NULL')
                       .where("finish > NOW() - INTERVAL '30 days'")
                       .order("finish - start DESC")
                       .limit(5)
                       .each_with_object({}) do |l, memo|
      memo["#{l.scan_job.name} #{l.jid}"] = ((l.finish - l.start).round)/60
                       end
    [{name: 'Минут', data: result}]
  end
end
