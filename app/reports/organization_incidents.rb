# frozen_string_literal: true

module Reports
  class OrganizationIncidents
    attr_reader :file_name, :file

    def initialize
      @file_name = 'Инциденты организации.docx'
      @file = render.string
    end

    private

    def render
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

      docx.font name: 'Arial', size: 14

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

      #docx.page

      # docx.h1 'Справка по инцидентам организации'
      # docx.hr
      docx.p  'Справка по инцидентам организации', style: 'Header'
#      docx.ul do
#        li 'Custom page sizes and margins'
#        li 'Custom styles (including the manipulation of font, size, color, alignment, margins, leading, etc.)'
#        li 'Paragraph text, headings, and external links'
#        li 'Ordered and unordered lists'
#        li 'Images'
#        li 'Tables'
#        li 'Page numbers'
#      end
      Incident.all.each_with_index do |incident, index|
        docx.p
        docx.p "Инцидент - #{index}", style: 'Header'
        docx.p "(зарегистрирован #{incident.created_at})", style: 'SubHeader'
        docx.p "начался #{IncidentDecorator.new(incident).show_started_at})", style: 'Text'
        docx.p
        docx.p incident.event_description, style: 'Text'
      end
#      docx.h2 'Simple Tables'
#      docx.table [[1], [2], [3], [4]], border_size: 4 do
#        cell_style rows[0],    bold: true,   background: '3366cc', color: 'ffffff'
#        cell_style rows[-1],   bold: true,   background: 'dddddd'
#        cell_style cells[2],   italic: true, color: 'cc0000'
#        cell_style cols[0],    width: 6000
#        cell_style cells,      size: 18, margins: { top: 100, bottom: 0, left: 100, right: 100 }
#      end
      docx.render
    end
  end
end
