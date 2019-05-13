# frozen_string_literal: true

class IndicatorContextsDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_indicators_formats
    indicators_formats.map do |format|
      Indicator.human_enum_name(
        :content_format, format
      )
    end.join(', ')
  end
end
