module XForceParser
  def danger?(content)
    XForceParser.hash_danger?(content) ||
    XForceParser.ip_danger?(content) ||
    XForceParser.url_danger?(content) ||
    XForceParser.url_malware_danger?(content)
  end

  def kaspesky_danger_verdict(content)
    ''
  end

  def hash_danger?(content)
    (content.dig('malware', 'malware', 'risk') || '') == 'high'
  end

  def url_danger?(content)
    (content.dig('url', 'result', 'score') || 0) > 0
  end

  def url_malware_danger?(content)
    (content.dig('url/malware', 'count') || 0) > 0
  end

  def ip_danger?(content)
    (content.dig('ipr', 'score') || 0) > 0
  end

  module_function(
    :danger?,
    :kaspesky_danger_verdict,
    :hash_danger?,
    :url_danger?,
    :url_malware_danger?,
    :ip_danger?
  )

end
