# frozen_string_literal: true

class TagKindDecorator < SimpleDelegator
  def name_with_code
    "#{code_name} (#{name}) "
  end

  def show_record_type
    return I18n.t('labels.link_kind.all_resource_types') if record_type.blank?
    Tag.record_types[record_type]
  end
end
