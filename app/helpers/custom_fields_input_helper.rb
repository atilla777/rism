# frozen_string_literal: true

module CustomFieldsInputHelper
  def custom_fields_input(record)
    fields = record.class.custom_fields_list
    render(
      'helpers/custom_fields_input',
      fields: fields,
      record: record,
      resource: record.class.model_name.to_s.underscore,
    )
  end
end
