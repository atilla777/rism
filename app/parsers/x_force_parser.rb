class XForceParser < BaseParser
  def danger?
    hash_danger? ||
    ip_danger? ||
    url_danger? ||
    url_malware_danger?
  end

  def danger_verdict
    nil
  end

  private

  def hash_danger?
    (@content.dig('malware', 'malware', 'risk') || '') == 'high'
  end

  def url_danger?
    (@content.dig('url', 'result', 'score') || 0) > 0
  end

  def url_malware_danger?
    (@content.dig('url/malware', 'count') || 0) > 0
  end

  def ip_danger?
    (@content.dig('ipr', 'score') || 0) > 0
  end
end
