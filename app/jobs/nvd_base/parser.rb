module NvdBase::Parser
  module_function

  def record_attributes(cve)
    products = []
    vendors_arr = cve.dig('cve', 'affects', 'vendor', 'vendor_data') || []
    versions = vendors_arr
    vendors = vendors_arr.each_with_object([]) do |vendor, arr|
      products_array = vendor.dig('product', 'product_data') || []
      products_array.each do |product|
        products << product.fetch('product_name', '')

#        versions = product.dig('version', 'version_data') || []
#        versions_arr = product.dig('version', 'version_data') || []
#        versions_arr.each do |version|
#          ver = version.fetch('version_value', '')
#          ver_aff = version.fetch('version_affected', '')
#          versions <<  {
#            vendor: vendor,
#            product: product,
#            version: ver,
#            version_affected: ver_aff
#          }
#        end

      end
      arr << vendor.fetch('vendor_name', '')
    end

    references_arr = cve.dig('cve', 'references', 'reference_data') || []
    references = references_arr.each_with_object([]) do |reference, arr|
      arr << reference.fetch('url', '')
    end
    feed_descriptions_arr = cve.dig('cve', 'description', 'description_data') || []
    feed_description = feed_descriptions_arr.each_with_object([]) do |description, arr|
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
      vendors: vendors,
      products: products,
      versions: versions,
      cpe: cve.dig('configurations', 'nodes') || [],
      cwe: cwe,
      cvss3: cve.dig('impact', 'baseMetricV3', 'cvssV3', 'baseScore')&.to_d,
      cvss3_vector: cve.dig('impact', 'baseMetricV3', 'cvssV3', 'vectorString') || '',
      cvss3_exploitability: cve.dig('impact', 'baseMetricV3', 'exploitabilityScore')&.to_d,
      cvss3_impact: cve.dig('impact', 'baseMetricV3', 'impactScore')&.to_d,
      cvss2: cve.dig('impact', 'baseMetricV2', 'cvssV2', 'baseScore')&.to_d,
      cvss2_vector: cve.dig('impact', 'baseMetricV2', 'cvssV2', 'vectorString') || '',
      cvss2_exploitability: cve.dig('impact', 'baseMetricV2', 'exploitabilityScore')&.to_d,
      cvss2_impact: cve.dig('impact', 'baseMetricV2', 'impactScore')&.to_d,
      references: references,
      published: cve.dig('publishedDate'),
      published_time: true,
      modified: cve.dig('lastModifiedDate'),
      modified_time: true,
      feed: Vulnerability.feeds[:nvd],
      feed_description: feed_description
    }
  end
end
