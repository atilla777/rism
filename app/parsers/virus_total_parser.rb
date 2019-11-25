module VirusTotalParser
  def danger?(content)
    hash_or_uri_danger = content.fetch('scans', {}).any? do |antivirus, value|
      value.fetch('detected', false)
    end
    return true if hash_or_uri_danger
    content.fetch('detected_urls', {}).any? do |url|
      url.fetch('positives', 0) > 0
    end
  end

  def kaspesky_danger_verdict(content)
    content.fetch('scans', {})
      .find do |antivirus, value|
        antivirus == 'Kaspersky' && value.fetch('detected', false)
    end&.second&.fetch('result', '')
  end

#  def danger?(content, content_format)
#    case Indicator::Enrichments.map_hash_format(content_format)
#    when 'hash', 'uri'
#      content.fetch('scans', {}).any? do |antivirus, value|
#        value.fetch('detected', false)
#      end
#    when 'network', 'domain'
#      content.fetch('detected_urls', {})
#        .any? do |url|
#          url.fetch('positives', 0) > 0
#      end
#    else
#      false
#    end
#  end

  module_function :danger?, :kaspesky_danger_verdict
end
