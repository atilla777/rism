# frozen_string_literal: true

class SyncNvdBaseJob < ApplicationJob
  require 'zlib'

  NVD_JSON_VERSION = '1.1'.freeze
  NVD_BASE_PATH = "https://nvd.nist.gov/feeds/json/cve/#{NVD_JSON_VERSION}/".freeze
  NVD_MODIFIED_FILE = 'modified.json.gz'.freeze
  NVD_MODIFIED_META_FILE = 'modified.meta'.freeze

  Sidekiq.default_worker_options = { 'retry' => 0 }

  queue_as do
    self.arguments&.first || :default
  end

  def perform(_)
    return if meta_not_changed?
    download_gz_file
    extract_gz_file
    delete_gz_file
    save_to_base
    delete_file
  end

  private

  def meta_not_changed?
    old_meta = old_meta()
    new_meta = download_meta()
    return true if new_meta == old_meta
    File.delete
    save_meta(new_meta)
    false
  end

  def old_meta
    return '' unless File.file?(meta_path)
    File.open(meta_path) { |file| file.read}
  end

  def download_meta
    begin
      HTTParty.get(meta_uri, options)
              .response
              .body
    rescue StandardError
      logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
      logger.tagged("SYNC_NVD (#{Time.now}):") do
        logger.error("meta file can`t be saved (network error?)")
      end
    end
  end

  def save_meta(string)
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
      HTTParty.get(uri, options.merge(stream_body: true)) do |fragment|
        file.write(fragment)
      end
    end
  end

  def options
    return {} if ENV['PROXY_SERVER'].blank?
    {
      verify: false,
      http_proxyaddr: ENV['PROXY_SERVER'],
      http_proxyport: ENV['PROXY_PORT'],
      http_proxyuser: ENV['PROXY_USER'],
      http_proxypass: ENV['PROXY_PASSWORD']
    }
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
      attributes = NvdBase::Parser.record_attributes(cve)
      begin
        record = Vulnerability
          .find_or_initialize_by(codename: attributes[:codename])
        record.update_attributes!(
          attributes.merge(
            relevance: 'not_set'
          )
        )
      rescue ActiveRecord::RecordInvalid
        logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_erros.log'))
        logger.tagged("SYNC_NVD (#{Time.now}): #{record.codename}") do
          logger.error <<-TEXT
            vulnerability can`t be saved -
            #{record.errors.full_messages}
          TEXT
        end
      end
    end
  end

  def delete_gz_file
    File.delete(gz_save_path)
  end

  def delete_file
    File.delete(save_path)
  end
end
