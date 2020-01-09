# frozen_string_literal: true

class HostsReport < BaseReport
  include DateTimeHelper

  set_lang :ru
  set_report_name :hosts
  set_human_name 'Хосты'
  set_report_model 'Host'
  set_required_params %i[]
  set_formats %i[docx csv]

  def docx(blank_document)
    r = blank_document
    r.page_size do
      width       16837 # sets the page width. units in twips.
      height      11905 # sets the page height. units in twips.
      orientation :landscape  # sets the printer orientation. accepts :portrait and :landscape.
    end
    if @organization.present?
      r.p  "Справка по хостам организации #{@organization.name}", style: 'Header'
    else
      r.p  "Справка по хостам организаций", style: 'Header'
    end
    r.p  "(по состоянию на #{Date.current.strftime('%d.%m.%Y')})", style: 'Prim'

    header = [[
      'Организация',
      'IP-адрес/подсеть',
      'Название',
      'Описание'
    ]]

    table = @records.each_with_object(header) do |record, memo|
      row = []
      record = HostDecorator.new(record)
      row << "#{record.organization.name}"
      row << "#{record.show_ip}"
      row << "#{record.name}"
      row << "#{record.description}"
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
      'Организация',
      'IP-адрес/подсеть',
      'Название',
      'Описание'
    ]
    r. << header

    @records.each do |record|
      row = []
      record = HostDecorator.new(record)
      row << "#{record.organization.name}"
      row << "#{record.show_ip}"
      row << "#{record.name}"
      row << "#{record.description}"
      r << row
    end
  end

  private

  def get_records(options, organization)
    scope = Host
    if organization.present?
      scope = scope.where(organization_id: organization.id)
    end
    Pundit.policy_scope(current_user, scope)
      .includes(:organization)
      .order('organizations.name')
      .order(:ip)
  end
end
