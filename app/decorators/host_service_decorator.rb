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
    return '' if state.blank?
    ScanResult.human_attribute_states[state]
  end

  def show_state2
    scope = ScanResult.where(ip: host.ip, port: port, protocol: protocol)
    result = ScanResultsQuery.new(scope)
                    .last_results
                    .first
    if result.present? 
      ScanResult.human_enum_name(:states, result.state)
    else
      ''
    end
  end
end
