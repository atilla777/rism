# frozen_string_literal: true

class ResetNvdBaseJob < ApplicationJob
  require 'zlib'

  NVD_JSON_VERSION = '1.0'.freeze
  NVD_BASE_PATH = "https://nvd.nist.gov/feeds/json/cve/#{NVD_JSON_VERSION}/".freeze
  MASS_SAVE_LIMIT = 10

  Sidekiq.default_worker_options = { 'retry' => 2 }

  queue_as do
    self.arguments&.first || :default
  end

  def perform(_, year)
    download_gz_file(uri(year), gz_save_path(year))
    extract_gz_file(gz_save_path(year), year)
    delete_gz_file(year)
    save_to_base(year)
    delete_file(year)
  end

  private

  def mass_save_limit
    MASS_SAVE_LIMIT
  end

  def uri(year)
    "#{NVD_BASE_PATH}nvdcve-#{NVD_JSON_VERSION}-#{year}.json.gz"
  end

  def save_folder
    Rails.root.join('tmp','vulners')
  end

  def gz_save_path(year)
    "#{save_folder}/#{year}.gz"
  end

  def save_path(year)
    "#{save_folder}/#{year}"
  end

  def download_gz_file(uri, gz_save_path)
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

  def extract_gz_file(path, year)
    Zlib::GzipReader.open(path) { |gz_file|
      extracted_file = File.new(save_path(year), "w")
      extracted_file.write(gz_file.read)
      extracted_file.close
    }
  end

  def save_to_base(year)
    Oj.load_file(save_path(year)).fetch('CVE_Items', []).each do |cve|
      begin
        record = Vulnerability.new(
          NvdBase::Parser.record_attributes(cve)
            .merge(
              relevance: 'not_set',
              custom_actuality: 'not_set',
              custom_relevance: 'not_set'
            )
        )
        record.save!
      rescue ActiveRecord::RecordInvalid
        logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
        logger.tagged("RESET_NVD (#{Time.now}):}") do
          logger.error("vulnerability can`t be saved - #{record.errors.full_messages}, record:  #{record.codename}")
        end
      end
    end
  end

# ++
# TODO: use or delete (should be faster, but it is slowly :()
#  def save_to_base(year)
#    @queue = []
#    Oj.load_file(save_path(year))
#      .fetch('CVE_Items', [])
#      .each do |cve|
#        attributes = NvdBase::Parser.record_attributes(cve)
#        attributes[:modified] ||= attributes[:published]
#        attributes.merge!(
#              relevance: 'not_set',
#              custom_actuality: 'not_set',
#              custom_relevance: 'not_set'
#        )
#        queue_to_save(attributes)
#      end
#    save if @queue.present?
#  end
#
#
#  def queue_to_save(attributes)
#    @queue << Vulnerability.new(attributes)
#    return if @queue.size < mass_save_limit
#    save
#  end
#
#  def save
#    result = Vulnerability.mass_save(
#      @queue,
#      mass_save_limit: mass_save_limit
#    )
#    log_errors(result.failed_instances)
#  end
#
#  def log_errors(records)
#    records.each do |record|
#      logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
#      logger.tagged("RESET_NVD (#{Time.now}): #{record}") do
#        logger.error("vulnerability can`t be saved - #{record.errors.full_messages}, record:  #{record}")
#      end
#    end
#  end
# ++

  def delete_gz_file(year)
    File.delete(gz_save_path(year))
  end

  def delete_file(year)
    File.delete(save_path(year))
  end
end
