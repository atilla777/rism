# frozen_string_literal: true

module StripTextFields
  extend ActiveSupport::Concern

  included do
    before_validation :strip_string_fields
  end

  private

  def strip_string_fields
    string_columns = self.class.columns.select { |column| column.type == :string }
    string_columns.each do |string_column|
      attribute = string_column.name
      value = send(attribute)
      if value.is_a?(String)
        send("#{attribute}=", value.strip) if value.present?
      end
    end
    true
  end
end
