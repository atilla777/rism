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
    r.style id: 'header', name: 'Header' do
      font 'Times New Roman'
      size 28
      bold true
      align :center
    end
    r.style id: 'text_header', name: 'TextHeader' do
      type 'character'
      font 'Times New Roman'
      size 28
      bold true
    end
    r.style id: 'subheader', name: 'Subheader' do
      font 'Times New Roman'
      size 24
      bold true
      align :both
      #indent_first 720
    end
    r.style id: 'text_subheader', name: 'TextSubheader' do
      type 'character'
      font 'Times New Roman'
      size 24
      bold true
      #indent_first 720
    end
    r.style id: 'text', name: 'Text' do
      font 'Times New Roman'
      size 24
      bold false
      align :both
      indent_first 0
      top 0
      bottom 0
    end
    r.style id: 'text_text', name: 'TextText' do
      type 'character'
      font 'Times New Roman'
      size 24
      bold false
    end

    investigation = @investigation

    r.p do
      style 'Header'
      text "Бюллетень индикаторов компрометации", style: 'TextHeader', color: '990066'
    end
    if investigation.name != investigation.investigation_kind.name
      r.p  investigation.name, style: 'Header'
    end
    r.p  "№ #{investigation.custom_codename}", style: 'Header'
    r.p  "(по состоянию на #{Date.current.strftime('%d.%m.%Y')})", style: 'Prim', size: 20
    r.p
    r.p do
      text "Тип события: ", style: 'TextSubheader', color: '990066'
      text investigation.investigation_kind.name, style: 'TextText'
    end
    r.p do
      text "Источник информации: ", style: 'TextSubheader', color: '990066'
      if investigation.feed_codename.present?
        text(
          "#{investigation.feed.name} (#{investigation.feed_codename})",
          style: 'TextText'
         )
      else
        text investigation.feed.name, style: 'TextText'
      end
    end
    r.p style: 'Text' do
      text investigation.description, style: 'TextText'
    end
    r.p
    r.p  "Индикаторы:", style: 'TextSubheader', color: '990066'
    r.hr do
      color   '990066'   # sets the color of the line. defaults to auto.
      line    :double    # sets the line style (single or double). defaults to single.
      size    8          # sets the thickness of the line. units in 1/8 points. defaults to 4.
      spacing 4          # sets the spacing around the line. units in 1/8 points. defaults to 1.
    end
    investigation.top_parents_indicators.each do |top_parent|
      print_indicator(r, top_parent, self)
      r.hr color: '990066'
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
      text space
      text "#{i.show_content_format}", style: 'TextSubheader', color: '990066'
      if i.show_indicator_contexts.present?
        text " (#{i.show_indicator_contexts})", style: 'TextSubheader'
      end
      purpose = case i.purpose
                when 'for_detect'
                  ' - для поиска'
                when 'for_prevent'
                  ' - для поиска и блокировки'
                else
                  ''
                end
      text "#{purpose}:", style: 'TextSubheader'
      br
      text space
      text  i.show_escaped_content, style: 'TextText', color: 'ff1493'
      if i.description.present?
        br
        text space
        text i.description, style: 'TextText', italic: true
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
