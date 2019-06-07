# frozen_string_literal: true
class IndicatorDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_content_format
    Indicator.human_enum_name(:content_format, content_format)
  end

  def show_indicator_contexts
    indicator_contexts.map do |context|
      context.name
    end.join(', ')
  end

  def show_purpose
    Indicator.human_enum_name(:purpose, purpose)
  end

  def show_trust_level
    Indicator.human_enum_name(:trust_level, trust_level)
  end

  def show_appearance
    Indicator.where(content: content).count
  end
end
