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

  def self.set_required_params(name)
    define_singleton_method(:required_params) { name }
  end

  def docx
    docx = Caracal::Document.new('report.docx')
    docx.page_size do
      width       15840       # sets the page width. units in twips.
      height      12240       # sets the page height. units in twips.
      orientation :portrait # sets the printer orientation. accepts :portrait and :landscape.
    end
    docx.page_margins do
      left    720     # sets the left margin. units in twips.
      right   720     # sets the right margin. units in twips.
      top     1440    # sets the top margin. units in twips.
      bottom  1440    # sets the bottom margin. units in twips.
    end
    docx.page_numbers true do
      align :right
    end
    docx.font name: 'Arial', size: 28
    docx.style id: 'header', name: 'Header' do
      font 'Arial'
      size 28
      bold true
      align :center
    end
    docx.style id: 'subheader', name: 'SubHeader' do
      font 'Arial'
      size 28
      bold false
      align :center
    end
    docx.style id: 'text', name: 'Text' do
      font 'Arial'
      size 28
      bold false
      align :both
      indent_first 720
      top 0
      bottom 0
    end
    report(docx)
    docx
  end

  attr_reader :file_content, :file_name, :options, :current_user

  def initialize(current_user, options = {})
    @current_user = current_user
    @file_name = "#{self.class.human_name}.docx"
    @options = options
    @file_content = docx.render.string
  end
end

