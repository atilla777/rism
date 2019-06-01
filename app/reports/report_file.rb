class ReportFile
  attr_reader :file_name, :file_content

  def initialize(report_human_name)
    @file_name = set_file_name(report_human_name)
    @file_content = blank_document
  end

  def document_preset; end

  def set_file_name
    raise StandartError, 'Method shuld be defined in sublcass.'
  end

  def render
    raise StandartError, 'Method shuld be defined in sublcass.'
  end

  def initialization_preset
    @level = 0
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
end
