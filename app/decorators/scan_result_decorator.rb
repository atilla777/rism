# frozen_string_literal: true
class ScanResultDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_state
    ScanResult.human_enum_name(:states, state)
  end

  def show_legality
    ScanResult.human_enum_name(:legalities, legality)
  end

  def show_current_legality
    current_legality = HostService.legality(ip, port, protocol, state)
    ScanResult.human_enum_name(:legalities, current_legality)
  end

  def show_current_legality_with_color
    current_legality = HostService.legality(ip, port, protocol, state)
    [ ScanResult.human_enum_name(:legalities, current_legality),
      ScanResult.legality_to_color(ScanResult.legalities[current_legality])
    ]
  end

  def show_legality_with_color
    [ ScanResult.human_enum_name(:legalities, legality),
      ScanResult.legality_to_color(ScanResult.legalities[legality])
    ]
  end

  def show_service
    service || ''
  end

  def show_product
    product || ''
  end

  def show_product_version
    product_version || ''
  end

  def show_product_extrainfo
    product_extrainfo || ''
  end

  def show_vulners
    return '' if vulners.empty?
    "#{I18n.t('activerecord.attributes.host_service.vulnerable')}"
  end

  def show_vulners_names
    return '' if vulners.empty?
    vulners.each_with_object([]) do |v, memo|
      memo << v.fetch('cve')
    end.join('; ')
  end
end
