# frozen_string_literal: true
class IndicatorDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_ioc_kind
    Indicator.human_enum_name(:ioc_kind, ioc_kind)
  end

  def show_trust_level
    Indicator.human_enum_name(:trust_level, trust_level)
  end

  def show_investigation_full_name
    "##{investigation.id}: #{investigation.name}"
  end
end
