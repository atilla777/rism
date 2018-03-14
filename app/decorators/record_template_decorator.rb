# frozen_string_literal: true

class RecordTemplateDecorator < SimpleDelegator

  def show_record_type
    RecordTemplate.record_types[record_type]
  end
end
