# frozen_string_literal: true

class InvestigationReport < BaseReport
  include DateTimeHelper

  set_lang :ru
  set_report_name :investigation_report
  set_human_name 'Бюллетень индикаторов компроментации'
  set_report_model 'Investigation'
  set_required_params %i[investigation_id]
  set_formats %i[docx csv]

  def docx(blank_document)
    r = blank_document
    r.page_size do
      width       16837 # sets the page width. units in twips.
      height      11905 # sets the page height. units in twips.
      orientation :landscape  # sets the printer orientation. accepts :portrait and :landscape.
    end

    r.p  "Бюллетень индикаторов компрометации", style: 'Header'
    r.p  "(по состоянию на #{Date.current.strftime('%d.%m.%Y')})", style: 'Prim'
    r.p
    r.p  "Общая информация:", style: 'Subheader'
    r.p  @investigation.description, style: 'Text'
    r.p
    r.p  "Тип события:", style: 'Subheader'
    r.p  @investigation.investigation_kind.name, style: 'Text'
    r.p
    r.p  "Источник информации:", style: 'Subheader'
    r.p  @investigation.feed.name, style: 'Text'
    r.p
    r.p  "Индикаторы", style: 'Header'
    header = [[
      '№ п.',
      'Формат индикатора',
      'Контекст индикатора',
      'Уровень доверия',
      'Назначение',
      'Значение',
      'Дата сохранения в базе',
      'Дата обновления в базе',
      'Примечания',
    ]]

    @i = 0
    table = @records.each_with_object(header) do |r, memo|
      @i += 1
      row = []

      record = IndicatorDecorator.new(r)

      row << @i
      row << record.show_content_format
      row << record.show_indicator_contexts
      row << record.show_trust_level
      row << record.show_purpose
      row << record.content
      row << show_date_time(record.created_at)
      row << show_date_time(record.updated_at)
      row << record.description
      memo << row
    end
    r.p
    r.table(table, border_size: 4) do
      cell_style rows[0],    bold: true,   background: '3366cc', color: 'ffffff'
      cell_style cells,      size: 20, margins: { top: 100, bottom: 0, left: 100, right: 100 }
     end
  end

  def csv(blank_document)
    r = blank_document

    header = [
      '№ п.',
      'Исследование (бюллетень)',
      'Источник информации',
      'Формат индикатора',
      'Контекст индикатора',
      'Уровень доверия',
      'Назначение',
      'Значение',
      'Дата сохранения в базе',
      'Дата обновления в базе',
      'Примечания',
      'Описание исследования (бюллетеня)'
    ]
    r. << header

    @records.each_with_index do |record, index|
      row = []
      record = IndicatorDecorator.new(record)

      row << index + 1
      row << @investigation.name
      row << @investigation.feed.name
      row << record.show_content_format
      row << record.show_indicator_contexts
      row << record.show_trust_level
      row << record.show_purpose
      row << record.content
      row << show_date_time(record.created_at)
      row << show_date_time(record.updated_at)
      row << record.description
      row << @investigation.description

      r << row
    end
  end

  private

  def get_records(options, _organization)
    @investigation = Investigation.find(options[:investigation_id])
    @investigation.indicators
  end
end
