class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # translate enum fields
  def self.human_enum_name(enum_name, enum_value)
    model = model_name.i18n_key
    attr = enum_name.to_s.pluralize
    I18n.t("activerecord.attributes.#{model}.#{attr}.#{enum_value}")
  end
end
