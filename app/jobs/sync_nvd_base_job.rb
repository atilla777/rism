# frozen_string_literal: true

class SyncNvdBaseJob < ApplicationJob
  require 'zlib'

  NVD_JSON_VERSION = '1.0'.freeze
  NVD_BASE_PATH = "https://nvd.nist.gov/feeds/json/cve/#{NVD_JSON_VERSION}/".freeze
  NVD_MODIFIED_FILE = 'modified.json.gz'.freeze
  NVD_MODIFIED_META_FILE = 'modified.meta'.freeze

  Sidekiq.default_worker_options = { 'retry' => 0 }

  queue_as do
    #self.arguments.first&.present? ? self.arguments.first : :default
    self.arguments&.first || :default
  end

  def perform(_)
    return if modified_meta_not_changed?
    download_gz_file
    extract_gz_file
    delete_gz_file
    save_to_base
    delete_file
  end

  private

  def modified_meta_not_changed?
    old_modified_meta = old_modified_meta()
    new_modified_meta = download_modified_meta()
    return true if new_modified_meta == old_modified_meta
    File.delete
    save_modified_meta(new_modified_meta)
    false
  end

  def old_modified_meta
    return '' unless File.file?(meta_path)
    File.open(meta_path) { |file| file.read}
  end

  def download_modified_meta
    HTTParty.get(meta_uri)
            .response
            .body
  rescue StandardError
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_erros.log'))
    logger.tagged("SYNC_NVD: #{record}") do
      logger.error("modifeitd meta can`t be downloaded - #{record.errors.full_messages}")
    end
  end

  def save_modified_meta(string)
    FileUtils.mkdir_p(save_folder) unless File.directory?(save_folder)
    File.open(meta_path, 'w') {|file| file.write string}
  end

  def uri
    "#{NVD_BASE_PATH}nvdcve-#{NVD_JSON_VERSION}-#{NVD_MODIFIED_FILE}"
  end

  def meta_uri
    "#{NVD_BASE_PATH}nvdcve-#{NVD_JSON_VERSION}-#{NVD_MODIFIED_META_FILE}"
  end

  def save_folder
    Rails.root.join('tmp','vulners')
  end

  def gz_save_path
    "#{save_folder}/modified.gz"
  end

  def save_path
    "#{save_folder}/modified"
  end

  def meta_path
    "#{Rails.root.join('tmp', 'vulners')}/sync_meta"
  end

  def download_gz_file
    File.open(gz_save_path, "w") do |file|
      file.binmode
      HTTParty.get(uri, stream_body: true) do |fragment|
        file.write(fragment)
      end
    end
  end

  def extract_gz_file
    Zlib::GzipReader.open(gz_save_path) { |gz_file|
      extracted_file = File.new(save_path, "w")
      extracted_file.write(gz_file.read)
      extracted_file.close
    }
  end

  def save_to_base
    Oj.load_file(save_path).fetch('CVE_Items', []).each do |cve|
      attributes = record_attributes(cve)
      Vulnerability.find_or_initialize_by(codename: attributes[:codename])
                   .update_attributes!(attributes)
    end
  rescue ActiveRecord::RecordInvalid
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_erros.log'))
    logger.tagged("SYNC_NVD: #{record}") do
      logger.error("vulnerability can`t be saved - #{record.errors.full_messages}")
    end
  end

  def record_attributes(cve)
    products = []
    vendors_arr = cve.dig('cve', 'affects', 'vendor', 'vendor_data') || []
    versions = vendors_arr
    vendors = vendors_arr.each_with_object([]) do |vendor, arr|
      products_array = vendor.dig('product', 'product_data') || []
      products_array.each do |product|
        products << product.fetch('product_name', '')

#        versions = product.dig('version', 'version_data') || []
 #       versions_arr = product.dig('version', 'version_data') || []
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
    {
      codename: cve.dig('cve', 'CVE_data_meta', 'ID'),
      vendors: vendors,
      products: products,
      versions: versions,
      cvss3: cve.dig('impact', 'baseMetricV3', 'cvssV3', 'baseScore') || '',
      cvss3_vector: cve.dig('impact', 'baseMetricV3', 'cvssV3', 'vectorString') || '',
      references: references,
      published: cve.dig('publishedDate'),
      published_time: true,
      feed: Vulnerability.feeds[:nvd],
      feed_description: feed_description
    }
  end

  def delete_gz_file
    File.delete(gz_save_path)
  end

  def delete_file
    File.delete(save_path)
  end
end
