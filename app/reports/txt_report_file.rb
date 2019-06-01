#TXT file
class TxtReportFile < ReportFile
  def render
    @file_content
  end

  private

  def set_file_name(report_human_name)
    "#{report_human_name}.txt"
  end


  def blank_document
    ''
  end
end
