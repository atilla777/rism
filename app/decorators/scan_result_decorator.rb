# frozen_string_literal: true

class ScanResultDecorator < SimpleDelegator
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
end
