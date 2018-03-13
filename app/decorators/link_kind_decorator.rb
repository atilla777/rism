# frozen_string_literal: true

class LinkKindDecorator < SimpleDelegator
  def show_long_name
    "#{code_name} (#{name}) "
  end

  def show_first_record_type
    return I18n.t('labels.link_kind.all_resource_types') if first_record_type.blank?
    Link.record_types[first_record_type]
  end

  def show_second_record_type
    Link.record_types[second_record_type]
  end

  def show_equal
    if equal
      I18n.t('labels.link_kinds.equal')
    else
      I18n.t('labels.link_kinds.not_equal')
    end
  end

  def name_with_code
    "#{code_name} (#{name}) "
  end
end
