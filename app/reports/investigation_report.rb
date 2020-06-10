# frozen_string_literal: true

class InvestigationReport < BaseReport
  include DateTimeHelper

  set_lang :ru
  set_report_name :investigation_report
  set_human_name 'Бюллетень индикаторов компрометации'
  set_report_model 'Investigation'
  set_required_params %i[investigation_id]
  set_formats %i[docx csv]

  def docx(blank_document)
    r = blank_document
    r.page_size do
      #width       16837 # sets the page width. units in twips.
      #height      11905 # sets the page height. units in twips.
      #orientation :landscape  # sets the printer orientation. accepts :portrait and :landscape.
      orientation :portrait # sets the printer orientation. accepts :portrait and :landscape.
    end

    r.style id: 'ParagraphHeader', name: 'ParagraphHeader' do
      font 'Times New Roman'
      align :center
      top 0
      bottom 0
      line 230
    end

    r.style id: 'ParagraphContent', name: 'ParagraphContent' do
      font 'Times New Roman'
      align :left
      top 0
      bottom 100
      line 230
    end

    r.style id: 'ParagraphBreak', name: 'ParagraphBreak' do
      font 'Times New Roman'
      size 12
      top 0
      bottom 0
    end

    r.style id: 'TextMainHeader', name: 'TextMainHeader' do
      font 'Times New Roman'
      type 'character'
      size 28
      bold true
      color '154360'
    end

    r.style id: 'TextHeader', name: 'TextHeader' do
      font 'Times New Roman'
      type 'character'
      size 24
      bold true
      color '154360'
    end

    r.style id: 'TextContent', name: 'TextContent' do
      font 'Times New Roman'
      type 'character'
      size 24
    end

    r.style id: 'TextContentDanger', name: 'TextContentDanger' do
      font 'Times New Roman'
      type 'character'
      size 24
      color 'B03A2E'
    end

    investigation = @investigation

    r.p do
      style  'ParagraphHeader'
      text "Бюллетень индикаторов компрометации", style: 'TextMainHeader'
    end

    if investigation.name != investigation.investigation_kind.name
      r.p do
        style  'ParagraphHeader'
        text investigation.name, style: 'TextContent'
      end
    end

    r.p  do
      style  'ParagraphHeader'
      text "№ #{investigation.custom_codename}", style: 'TextHeader'
    end

    r.p do
      style  'ParagraphHeader'
      text(
        "(по состоянию на #{Date.current.strftime('%d.%m.%Y')})",
        style: 'TextContent',
        size: 20
      )
    end

    r.p style: 'ParagraphBreak'

    r.p do
      style  'ParagraphContent'
      text "Тип события: ", style: 'TextHeader'
      text investigation.investigation_kind.name, style: 'TextContent'
    end

    r.p do
      style  'ParagraphContent'
      text "Источник информации: ", style: 'TextHeader'
      if investigation.feed_codename.present?
        text(
          "#{investigation.feed.name} (#{investigation.feed_codename})",
          style: 'TextContent'
        )
      else
        text investigation.feed.name, style: 'TextContent'
      end
    end

    r.p style: 'ParagraphBreak'

    r.p style: 'ParagraphContent' do
      description = investigation.description.split("\n")&.map { |i| i.remove("\r") }
      description.each do |d|
       text d, style: 'TextContent'
       br if d != description.last
      end
    end

    r.p style: 'ParagraphBreak'

    r.p do
      style 'ParagraphContent'
      text "Индикаторы:", style: 'TextHeader'
    end

    r.hr do
      color '154360'
      size    20
      #spacing 4
    end

    investigation.top_parents_indicators.order(:content_format).each do |top_parent|
      print_indicator(r, top_parent, self)
      r.hr do
        color '154360'
        spacing 4
      end
    end
  end

  def csv(blank_document)
    r = blank_document

    header = [
      '№ п.',
      'Исследование (бюллетень)',
      'Источник информации',
      'Формат индикатора',
      'Значение',
      'Контекст индикатора',
      'Уровень доверия',
      'Назначение',
      'Примечания',
      'Дата сохранения в базе',
      'Дата обновления в базе',
      'Описание исследования (бюллетеня)'
    ]
    r. << header

    @records.each_with_index do |record, index|
      row = []
      record = IndicatorDecorator.new(record)

      row << index + 1
      row << "#{@investigation.custom_codename} #{@investigation.name}"
      row << @investigation.feed.name
      row << record.show_content_format
      row << record.content
      row << record.show_indicator_contexts
      row << record.show_trust_level
      row << record.show_purpose
      row << record.description
      row << show_date_time(record.created_at)
      row << show_date_time(record.updated_at)
      row << @investigation.description

      r << row
    end
  end

  def print_indicator(r, indicator, instance, space = '')
    space = space + '      '
    i = IndicatorDecorator.new(indicator)
    r.p do
      style 'ParagraphContent'
      text space
      text "#{i.show_content_format}", style: 'TextHeader'
      if i.show_indicator_contexts.present?
        text " (#{i.show_indicator_contexts})", style: 'TextContent'
      end
      purpose = case i.purpose
                when 'for_detect'
                  ' - для поиска'
                when 'for_prevent'
                  ' - для поиска и блокировки'
                else
                  ''
                end
      text "#{purpose}:", style: 'TextContent'
      br
      text space
      text  i.show_escaped_content, style: 'TextContentDanger'
      if i.description.present?
        br
        description = i.description.split("\n")
        description.each do |d|
         text space
         text d, style: 'TextContent', italic: true
         br if d != description.last
        end
      end
    end
    indicator.children.each do |child|
      instance.print_indicator(r, child, instance, space)
    end
  end

  private

  def get_records(options, _organization)
    @investigation = Investigation.find(options[:investigation_id])
    @investigation.indicators
  end
end
