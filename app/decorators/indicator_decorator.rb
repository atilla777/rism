# frozen_string_literal: true
class IndicatorDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def original_class
    __getobj__
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
    end.sort.join(', ')
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

  def enrichment_danger_detect?
    enrichment = enrichments.where(broker: :virus_total).last
    return false unless enrichment.present?
    case Indicator::Enrichments.map_hash_format(content_format)
    when 'hash', 'uri'
      enrichment.content.fetch('scans', {}).any? do |antivirus, value|
        value.fetch('detected', false)
      end
    when 'network', 'domain'
      enrichment.content.fetch('detected_urls', {})
        .any? do |url|
          url.fetch('positives', 0) > 0
      end
    else
      false
    end
  end

  def show_kaspesky_hash_enrichment
    enrichment = enrichments.where(broker: :virus_total).last
    return nil unless enrichment.present?
    unless Indicator::Enrichments.map_hash_format(content_format) == 'hash'
      return nil
    end
    enrichment.content.fetch('scans', {})
      .find do |antivirus, value|
        antivirus == 'Kaspersky' && value.fetch('detected', false)
    end&.second&.fetch('result', '')
  end
end
