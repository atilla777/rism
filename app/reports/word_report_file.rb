# DOCX Word file
class WordReportFile < ReportFile
  def render
    @file_content.render.string
  end

  private

  def set_file_name(report_human_name)
    "#{report_human_name}.docx"
  end

  def blank_document
    docx = Caracal::Document.new('report.docx')
    #    docx.page_size do
    #      width       15840       # sets the page width. units in twips.
    #      height      12240       # sets the page height. units in twips.
    #      orientation :portrait # sets the printer orientation. accepts :portrait and :landscape.
    #    end
    docx.page_margins do
      left    720     # sets the left margin. units in twips.
      right   720     # sets the right margin. units in twips.
      top     1440    # sets the top margin. units in twips.
      bottom  1440    # sets the bottom margin. units in twips.
    end
    docx.page_numbers true do
      align :right
    end
    docx.font name: 'Times New Roman', size: 28
    docx.style id: 'header', name: 'Header' do
      font 'Times New Roman'
      size 28
      bold true
      align :center
    end
    docx.style id: 'subheader', name: 'Subheader' do
      font 'Times New Roman'
      size 28
      bold true
      align :both
      indent_first 720
    end
    docx.style id: 'prim', name: 'Prim' do
      font 'Times New Roman'
      size 28
      bold false
      align :center
    end
    docx.style id: 'text', name: 'Text' do
      font 'Times New Roman'
      size 28
      bold false
      align :both
      indent_first 720
      top 0
      bottom 0
    end
    docx
  end
end
