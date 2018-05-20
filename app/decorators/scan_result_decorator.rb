# frozen_string_literal: true

class ScanResultDecorator < SimpleDelegator
  def show_state
    ScanResult.human_enum_name(:states, state)
  end

  def show_legality
    ScanResult.human_enum_name(:legalities, legality)
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
