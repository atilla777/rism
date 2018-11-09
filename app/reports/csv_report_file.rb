#CSV file
class CsvReportFile < ReportFile
  def render
    @file_content.string
  end

  private

  def set_file_name(report_human_name)
    "#{report_human_name}.csv"
  end

  def initialization_preset
    @level = 0
  end

  def blank_document
    CSV.new('', col_sep: ';') # , encoding: 'UTF8:Windows-1251'
  end

  # Top level document sections numeration counter and marker
  # Example:
  # "#{level} Part one"
  def level
    @sublevel = 0
    @level += 1
  end

  # Sublevel document sections numeration counter and marker
  # Example:
  # "#{level} Part one"
  # "#{sublevel} Capter one"
  def sublevel
    @sublevel += 1
    "#{@level}.#{@sublevel}"
  end

  # Correct display text_area field with several paragraphs
  # (paragraph is strings splited by \r or \n)
  # Example:
  # text_area(description) do |paragraph|
  #   docx.p paragraph
  # end
#  def text_area(text)
#    arr = text.split(/[\n\r]+/)
#    arr.each { |paragraph| yield(paragraph) }
#  end
end
