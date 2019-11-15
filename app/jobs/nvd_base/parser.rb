module NvdBase::Parser
  require 'hashie'

  CPE_REGEXP = %r{
    ^cpe:2\.3
    :[aoh{1}]
    :(?<vendor>(\\:|[^:])+)
    :(?<product>(\\:|[^:])+)
    :(?<version>(\\:|[^:])+)
    :(?<update>[^:]+)
    :(?<edition>(\\:|[^:])+)
    :(?<language>(\\:|[^:])+)
    :(?<sw_edition>(\\:|[^:])+)
    :(?<target_sw>(\\:|[^:])+)
    :(?<target_hw>(\\:|[^:])+)
    :(?<other>(\\:|[^:])+)
  }x.freeze

  module_function

  def record_attributes(cve)
    descriptions_arr = cve.dig('cve', 'description', 'description_data') || []
    description = descriptions_arr.each_with_object([]) do |description, arr|
      arr << description.fetch('value', '')
    end

    cwe_arr = cve.dig('cve', 'problemtype', 'problemtype_data') || []
    cwe = []
    cwe_arr.each do |hash|
      hash.fetch('description', []).each do |cwe_hash|
        cwe << cwe_hash.fetch('value', '')
      end
    end

    {
      codename: cve.dig('cve', 'CVE_data_meta', 'ID'),
      feed: Vulnerability.feeds[:nvd],
      vendors: vendors(cve),
      products: products(cve),
      cwe: cwe,
      cvss3: cve.dig('impact', 'baseMetricV3', 'cvssV3', 'baseScore')&.to_d,
      cvss3_vector: cve.dig('impact', 'baseMetricV3', 'cvssV3', 'vectorString') || '',
      cvss3_exploitability: cve.dig('impact', 'baseMetricV3', 'exploitabilityScore')&.to_d,
      cvss3_impact: cve.dig('impact', 'baseMetricV3', 'impactScore')&.to_d,
      cvss2: cve.dig('impact', 'baseMetricV2', 'cvssV2', 'baseScore')&.to_d,
      cvss2_vector: cve.dig('impact', 'baseMetricV2', 'cvssV2', 'vectorString') || '',
      cvss2_exploitability: cve.dig('impact', 'baseMetricV2', 'exploitabilityScore')&.to_d,
      cvss2_impact: cve.dig('impact', 'baseMetricV2', 'impactScore')&.to_d,
      description: description,
      published: cve.dig('publishedDate'),
      published_time: true,
      modified: cve.dig('lastModifiedDate'),
      modified_time: true,
      blocked: true,
      raw_data: cve
    }
  end

  def vendors(cve)
    vendors_products(cve).each_with_object([]) do |cve_hash, memo|
      vendor = cve_hash.fetch('vendor', '')
      memo <<  vendor unless memo.include?(vendor)
    end
  end

  def products(cve)
    vendors_products(cve).each_with_object([]) do |cve_hash, memo|
      product = cve_hash.fetch('product', '')
      memo <<  product unless memo.include?(product)
    end
  end

  def versions_by_products(cve)
    vendors_products(cve).each_with_object({}) do |cve, memo|
      memo[cve.fetch('vendor')] ||= {}
      memo[cve.fetch('vendor')][cve.fetch('product')] ||= []
      vendor_product = memo[cve.fetch('vendor')][cve.fetch('product')]
      vendor_product << cve.fetch('version')
      versions_range = []
      versions_range << ">= #{cve.fetch('>=')}" if cve.fetch('>=').present?
      versions_range << "> #{cve.fetch('>')}" if cve.fetch('>').present?
      versions_range << "<= #{cve.fetch('<=')}" if cve.fetch('<=').present?
      versions_range << "< #{cve.fetch('<')}" if cve.fetch('<').present?
      vendor_product << "[#{versions_range.join(' ... ')}]" if versions_range.present?
    end
  end

  def vendors_products(cve)
    return [] if cve == '{}'
    nodes = cve.dig('configurations', 'nodes')
    return [] if nodes.blank?
    nodes.extend(Hashie::Extensions::DeepLocate)
    nodes_arr = nodes.deep_locate -> (key, value, object) do
      key == 'vulnerable' && value == true
    end
    nodes_arr.each_with_object([]) do |node, memo|
      cve_str = node.fetch('cpe23Uri', false)
      next unless cve
      cve_hash = cve_str.match(CPE_REGEXP)&.named_captures || {}
      cve_hash = cve_hash.map { |k, v| [k, v.gsub('\\:', ':')] }.to_h
      cve_hash['>='] = node.fetch('versionStartIncluding', '')
      cve_hash['>'] = node.fetch('versionStartExcluding', '')
      cve_hash['<='] = node.fetch('versionEndIncluding', '')
      cve_hash['<'] = node.fetch('versionEndExcluding', '')
      memo << cve_hash
    end
  end
end
