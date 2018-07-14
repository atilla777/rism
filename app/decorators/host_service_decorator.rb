# frozen_string_literal: true

class HostServiceDecorator < SimpleDelegator
  def show_vulnerable
    return '' if vulnerable == false
    I18n.t('activerecord.attributes.host_service.vulnerable')
  end
end
