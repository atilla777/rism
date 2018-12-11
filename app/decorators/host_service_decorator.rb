# frozen_string_literal: true

class HostServiceDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_vulnerable
    return '' if vulnerable == false
    I18n.t('activerecord.attributes.host_service.vulnerable')
  end

  def show_state
    if state.blank?
      return I18n.t('activerecord.attributes.host_service.unknown_state')
    else
      ScanResult.human_attribute_states[state]
    end
  end
end
