# frozen_string_literal: true

module Indicator::Enrichments
  ENRICHMENTS = %w[
    virus_total
  ]

  HASH_FORMATS = %i[
    md5
    sha1
    sha256
    sha512
  ]

  module_function

  def enrichment_by_name(name)
    name if ENRICHMENTS.detect(name)
  end

  def map_hash_format(format)
    return 'hash' if HASH_FORMATS.any? { |e| e == format.to_sym }
    format
  end

  def format_supported?(format, service)
    case service
    when 'virus_total'
      IndicatorEnrichment::VirusTotalBrocker.format_supported?(format)
    end
  end
end
