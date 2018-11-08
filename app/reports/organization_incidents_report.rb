# frozen_string_literal: true

# To add report - add class (shown below) file into app/reports
# and register in reports.rb:
#
#  OrganizationIncidentsReport.register
class OrganizationIncidentsReport < BaseReport
  set_lang :ru
  set_report_name :organization_incidents
  set_human_name 'Инциденты организации'
  set_report_model 'Incident'
  set_required_params %i[organization_id]
  set_formats %i[docx]

  def docx(blank_document)
    r = blank_document

    # docx.h1 'Справка по инцидентам организации'
    # docx.hr
    r.p  "Справка по инцидентам связанным с организацией #{@organization.name}", style: 'Header'
    r.p  "(по состоянию на #{Date.current.strftime('%d.%m.%Y')})", style: 'Prim'
#      docx.ul do
#        li 'Custom page sizes and margins'
#        li 'Custom styles (including the manipulation of font, size, color, alignment, margins, leading, etc.)'
#        li 'Paragraph text, headings, and external links'
#        li 'Ordered and unordered lists'
#        li 'Images'
#        li 'Tables'
#        li 'Page numbers'
#      end
    @organization.me_linked_incidents.each do |incident|
      r.p
      r.p "#{level}. Инцидент ID #{incident.id} (#{incident.name})", style: 'Header'
      r.p "#{sublevel} Основные параметры инцидента", style: 'Subheader'
      r.p "Зарегистрирован: #{incident.created_at.strftime('%d.%m.%Y-%H:%M')}", style: 'Text'
      r.p "Обнаружен: #{IncidentDecorator.new(incident).show_discovered_at}", style: 'Text'
      r.p "Начался: #{IncidentDecorator.new(incident).show_started_at}", style: 'Text'
      r.p "Завершился: #{IncidentDecorator.new(incident).show_finished_at}", style: 'Text'
      r.p "Статус: #{IncidentDecorator.new(incident).show_state}", style: 'Text'
      r.p "Ущерб: #{IncidentDecorator.new(incident).show_damage}", style: 'Text'
      r.p "Важность: #{IncidentDecorator.new(incident).show_severity}", style: 'Text'
      r.p "#{sublevel} Описание инцидента", style: 'Subheader'
      text_area incident.event_description do |t|
        r.p t, style: 'Text'
      end
      text_area incident.investigation_description do |t|
        r.p t, style: 'Text'
      end
      text_area incident.action_description do |t|
        r.p t, style: 'Text'
      end
      r.p "#{sublevel} Связанные с инцидентом объекты", style: 'Subheader'
      incident.links.group_by { |link| "#{LinkKindDecorator.new(link.link_kind).name}" }.sort.each do |link_kind_name, links|
      r.p style: 'Text' do
          text "#{link_kind_name}: "
          result = []
          links.each do |link|
            result << link.second_record.show_full_name
            if link.description.present?
              result[-1] = result.last + " (#{link.description})"
            end
          end
          text result.join(', ')
        end
      end
      r.p "#{sublevel} Теги (метки) инцидента", style: 'Subheader'
      incident.tag_members.joins(tag: :tag_kind).where(tag_kinds: {record_type: 'Incident'}).group_by { |tag_member| "#{tag_member.tag.tag_kind.name}" }.sort.each do |tag_kind, tag_members|
        r.p style: 'Text' do
          text "#{tag_kind}: "
          result = []
          tag_members.each do |tag_member|
            result << tag_member.tag.name
          end
            text result.join(', ')
        end
      end
    end
#      docx.h2 'Simple Tables'
#      docx.table [[1], [2], [3], [4]], border_size: 4 do
#        cell_style rows[0],    bold: true,   background: '3366cc', color: 'ffffff'
#        cell_style rows[-1],   bold: true,   background: 'dddddd'
#        cell_style cells[2],   italic: true, color: 'cc0000'
#        cell_style cols[0],    width: 6000
#        cell_style cells,      size: 18, margins: { top: 100, bottom: 0, left: 100, right: 100 }
#      end
  end

  private

  def get_records(_options, _organization); end
end
