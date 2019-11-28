class VirusTotalParser < BaseParser
  ANTIVIRUS_FOR_VERDICT = 'Kaspersky'.freeze

  def danger?
    hash_or_uri_danger = @content.fetch('scans', {}).any? do |antivirus, value|
      value.fetch('detected', false)
    end
    return true if hash_or_uri_danger
    @content.fetch('detected_urls', {}).any? do |url|
      url.fetch('positives', 0) > 0
    end
  end

  def danger_verdict
    @content.fetch('scans', {})
      .find do |antivirus, value|
        antivirus == ANTIVIRUS_FOR_VERDICT && value.fetch('detected', false)
    end&.second&.fetch('result', nil)
  end
end
