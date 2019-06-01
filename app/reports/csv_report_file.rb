#CSV file
class CsvReportFile < ReportFile
  def render
    @file_content.string
  end

  private

  def set_file_name(report_human_name)
    "#{report_human_name}.csv"
  end

  def blank_document
    CSV.new('', col_sep: ';') # , encoding: 'UTF8:Windows-1251'
  end
end
