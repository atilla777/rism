# frozen_string_literal: true

class BaseReport
  def self.register
    Reports.add_report self
  end

  def self.set_lang(lang)
    define_singleton_method(:lang) { lang }
  end

  def self.set_report_name(name)
    define_singleton_method(:report_name) { name }
  end

  def self.set_human_name(name)
    define_singleton_method(:human_name) { name }
  end

  def self.set_report_model(name)
    define_singleton_method(:report_model) { name }
  end

  def self.set_formats(formats)
    define_singleton_method(:formats) { formats }
  end

  def self.set_required_params(name)
    define_singleton_method(:required_params) { name }
  end

  attr_reader :file, :file_name, :rendered_file, :options, :current_user

  def initialize(current_user, format, options = {})
    @current_user = current_user
    @options = options
    @human_name = self.class.human_name
    @organization = get_organization(options)
    @records = get_records(options, @organization)
    @file = blank_document(format)
    @file_name = @file.file_name
    @level = 0
    fill_in_report(format)
    @rendered_file = @file.render
  end

  private

  def get_organization(options)
    return nil unless options[:organization_id].present?
    OrganizationPolicy::Scope.new(current_user, Organization).resolve
      .where(id: options[:organization_id])
      .first
  end

  def fill_in_report(format)
    send(format, @file.file_content)
  end

  def blank_document(format)
    case format
    when :docx
      WordReportFile.new(@human_name)
    when :csv
      CsvReportFile.new(@human_name)
    when :txt
      TxtReportFile.new(@human_name)
    else
      raise ArgumentError, 'Unknown report format'
    end
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
  def text_area(text)
    arr = text.split(/[\n\r]+/)
    arr.each { |paragraph| yield(paragraph) }
  end
end
