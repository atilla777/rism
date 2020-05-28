# frozen_string_literal: true

class FiltredHostsReport < BaseReport
  include DateTimeHelper

  set_lang :ru
  set_report_name :filtred_hosts
  set_human_name 'Результаты поиска по полям'
  set_report_model 'Host'
  set_required_params %i[q]
  set_formats %i[csv]

  def csv(blank_document)
    r = blank_document

    header = [
      '№',
      'IP',
      'Имя',
      'Организация владелец',
      'Описание',
      'Время создания',
      'Время обновления',
    ]
    custom_fields = CustomField.where(field_model: 'Host')
    custom_fields_names = custom_fields.each_with_object([]) { |v, o| o << v.name }
    r. << (header + custom_fields_names)

    @records.each_with_index do |record, index|
      row = []
      record = HostDecorator.new(record)

      row << index + 1
      row << record.show_ip
      row << record.name
      row << record.organization.name
      row << record.description
      row << show_date_time(record.created_at)
      row << show_date_time(record.updated_at)

      custom_fields.each do |c|
        row << record.custom_field(c.name)
      end

      r << row
    end
  end

  private

  def get_records(options, organization)
    scope = Host.includes(
      :organization
    )

    scope = Pundit.policy_scope(current_user, Host)
                  .includes(:organization)

    if options[:q].present?
      q = scope.ransack(options[:q])
      q.sorts = options[:q].fetch('s', default_sort) #  default_sort if q.sorts.empty?
      q.result.limit(2000)
    else
      scope.all.limit(2000).sort(default_sort)
    end
  end

  def default_sort
    'created_at desc'
  end
end
