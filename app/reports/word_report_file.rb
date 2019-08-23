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
    docx.style id: 'text_subheader', name: 'TextSubheader' do
      type 'character'
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
    docx.style id: 'text_text', name: 'TextText' do
      type 'character'
      font 'Times New Roman'
      size 28
      bold false
      align :both
      indent_first 720
      top 0
      bottom 0
    end
    docx.list_style do
      type    :ordered    # sets the type of list. accepts :ordered or :unordered.
      level   2           # sets the nesting level. 0-based index.
      format  'decimal'   # sets the list style. see OOXML docs for details.
      value   '%3.'       # sets the value of the list item marker. see OOXML docs for details.
      align   :left       # sets the alignment. accepts :left, :center: and :right. defaults to :left.
      indent  400         # sets the indention of the marker from the margin. units in twips.
      left    800         # sets the indention of the text from the margin. units in twips.
      start   2           # sets the number at which item counts begin. defaults to 1.
      restart 1           # sets the level that triggers a reset of numbers at this level. 1-based index. 0 means numbers never reset. defaults to 1.
    end
    docx
  end
end
