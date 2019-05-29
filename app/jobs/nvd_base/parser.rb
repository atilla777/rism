module NvdBase::Parser
  module_function

  def record_attributes(cve)
    products = []
    vendors_arr = cve.dig('cve', 'affects', 'vendor', 'vendor_data') || []
    vendors = vendors_arr.each_with_object([]) do |vendor, arr|
      products_array = vendor.dig('product', 'product_data') || []
      products_array.each do |product|
        products << product.fetch('product_name', '')
      end
      arr << vendor.fetch('vendor_name', '')
    end
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
      vendors: vendors,
      products: products,
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
end
