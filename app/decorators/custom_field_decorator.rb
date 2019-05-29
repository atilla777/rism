# frozen_string_literal: true

class CustomFieldDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_field_model
    CustomField.field_models[field_model]
  end

  def show_data_type
    CustomField.human_enum_name(:data_type, data_type)
  end
end
