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

  def show_escaped_content
    formats = Indicator::Formats::ESCAPED_FORMATS
    return content unless formats.include?(content_format)
    if content_format == 'uri'
      content.gsub(/^(h|f)t(t?ps?:\/\/.*)/,'\1x\2')
    else
      content.gsub(/\.([^.]*)$/,'[.]\1')
    end
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

  def show_creator
    creator&.name || ''
  end

  def show_updater
    updater&.name || ''
  end

  def enrichment_done?
    return false if enrichment.empty?
    true
  end
end
