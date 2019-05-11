# frozen_string_literal: true

class IndicatorSubkindsDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_indicators_subkinds
    indicators_kinds.map do |indicator_kind|
      Indicator.human_enum_name(
        :content_kind, indicator_kind
      )
    end.join(', ')
  end
end
