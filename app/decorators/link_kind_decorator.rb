# frozen_string_literal: true

class LinkKindDecorator < SimpleDelegator
  def show_long_name
    "#{Link.record_types[record_type]} - #{code_name} (#{name})"
  end

  def show_record_type
    Link.record_types[record_type]
  end

  def show_equal
    equal ? I18n.t('labels.link_kinds.equal') : I18n.t('labels.link_kinds.not_equal')
  end

  def name_with_code
    "#{code_name} (#{name}) "
  end
end
