# frozen_string_literal: true

module CustomFieldable
  extend ActiveSupport::Concern

  included do
    def self.custom_fields_list
      CustomField.where(field_model: self.model_name.to_s)
    end

    def self.custom_fields_names
      self.custom_fields_list.pluck(:name)
    end
  end

  def custom_field(field_name)
    return if custom_fields.blank?
    custom_fields.detect { |name, _value| name == field_name }
                 &.last
  end

  def custom_field_data_type(field_name)
    CustomField.where(
      field_model: self.model_name.to_s,
      name: field_name
    )&.first&.data_type
  end

  def custom_fields_names
    self.class.custom_fields_names.merge(custom_fields.keys)
  end
end
