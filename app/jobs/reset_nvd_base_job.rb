# frozen_string_literal: true

class ResetNvdBaseJob < ApplicationJob
  require 'zlib'
  #require 'json/streamer'

  NVD_JSON_VERSION = '1.0'.freeze
  NVD_BASE_PATH = "https://nvd.nist.gov/feeds/json/cve/#{NVD_JSON_VERSION}/".freeze

  Sidekiq.default_worker_options = { 'retry' => 0 }

  queue_as do
    arg = self.arguments.first
    if arg.present?
      arg.to_sym
    else
      :default
    end
  end

  def perform(_, year)
    download_gz_file(uri(year), gz_save_path(year))
    extract_gz_file(gz_save_path(year), year)
    delete_gz_file(year)
    save_to_base(year)
    delete_file(year)
  end

  private

  def uri(year)
    "#{NVD_BASE_PATH}nvdcve-#{NVD_JSON_VERSION}-#{year}.json.gz"
  end

  def gz_save_path(year)
    download_folder = Rails.root.join('tmp')
    "#{download_folder}/#{year}.gz"
  end

  def save_path(year)
    download_folder = Rails.root.join('tmp')
    "#{download_folder}/#{year}"
  end

  def download_gz_file(uri, gz_save_path)
    File.open(gz_save_path, "w") do |file|
      file.binmode
      HTTParty.get(uri, stream_body: true) do |fragment|
        file.write(fragment)
      end
    end
  end

  def extract_gz_file(path, year)
    Zlib::GzipReader.open(path) { |gz_file|
      extracted_file = File.new(save_path(year), "w")
      extracted_file.write(gz_file.read)
      extracted_file.close
    }
  end

  def save_to_base(year)
#    file = File.open(save_path(year), 'r')
#    streamer = Json::Streamer.parser(file_io: file)
#    streamer.get(nesting_level: 2) do |cve|
#      record = Vulnerability.create(record_attributes(cve))
#      record.save!
#    end

    #file = File.open(save_path(year), 'r')
    Oj.load_file(save_path(year)).fetch('CVE_Items', []).each do |cve|
      record = Vulnerability.create(record_attributes(cve, year))
      record.save!
    end

#    hash = JSON.parse(file)
#    hash.fetch('CVE_Items', []).each do |cve|
#      record = Vulnerability.create(record_attributes(cve))
#      record.save!
#    end
  rescue ActiveRecord::RecordInvalid
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_erros.log'))
    logger.tagged("REST_NVD: #{record}") do
      logger.error("vulnerability can`t be saved - #{record.errors.full_messages}")
    end
  end

  def record_attributes(cve, year)
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
      year: year,
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

  def delete_gz_file(year)
    File.delete(gz_save_path(year))
  end

  def delete_file(year)
    File.delete(save_path(year))
  end
end
