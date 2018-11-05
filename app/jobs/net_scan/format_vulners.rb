class NetScan::FormatVulners
  def initialize(vulners, service)
    @vulners = vulners
    @service = service
  end

  def format
    send(@service.to_sym)
  end

  private

  def shodan
    return [] unless @vulners.fetch('vulns', false)
    @vulners['vulns'].each_with_object([]) do |(k,v), memo|
      result = {}
      result[:cve] = k
      result[:cvss] = v.fetch('cvss', 0)
      result[:references] = v.fetch('references', [])
      result[:verified] = v.fetch('verified', '')
      result[:summary] = v.fetch('summary', '')
      memo << result
    end
  end

  # https://vuldb.com
  def vuldb
    return [] unless @vulners.fetch('result', false)
    @vulners['result'].each_with_object([]) do |result, memo|
      response = {}
      cve = result.fetch('source', {}).fetch('cve', {})
      response[:cve] = cve.fetch('id', '')
      response[:cvss] = result.fetch('vulnerability', {}).fetch('cvss3', {}).fetch('basescore', 0)
      response[:references] = result.fetch('references', [])
      response[:verified] = result.fetch('verified', '')
      summary = []
      summary << result.fetch('entry', {}).fetch('title', '')
      summary << result.fetch('entry', {}).fetch('summary', '')
      response[:summary] = summary.reject(&:empty?).join('. ')
      memo << response
    end
  end

  # https://vulners.com
  def vulners
    return [] if @vulners.empty?
    return [] unless @vulners&.first.fetch('data', false)
    @vulners.fetch('data', {}).fetch.('search', []).each_with_object([]) do |vuln, memo|
      vuln = vuln.fetch('_source', {})
      result = {}
      result[:cve] = vuln.fetch('cvelist', []).join(', ')
      result[:cvss] = vuln.fetch('cvss', {}).fetch('score', 0)
      result[:references] = Array.new(1, vuln.fetch('href', ''))
      result[:verified] = ''
      result[:summary] = vuln.fetch('description', '')
      memo << result
    end
  end
end
