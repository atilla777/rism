# frozen_string_literal: true
require 'tornados'
require 'fileutils'

class TornadosService
  def self.call
    new.send(:execute)
  end

  def self.tornados_storage_path
    Rails.root.join('tmp', 'tornados')
  end


  def self.result_file_path
    Rails.root.join(TornadosService.tornados_storage_path, Tornados::FileWriter.default_result_file)
  end

  private

  def execute
    tor_exit_nodes = Tornados::NodesFetcher.call
    prepare_storage
    geobase_file_path = Tornados::MaxDbFetcher.call(max_mind_key, tornados_storage_path)
    enriched_tor_exit_nodes = Tornados::GeoEnrich.call(tor_exit_nodes, geobase_file_path, filter)
    csv_enriched_tor_exit_nodes = Tornados::CsvFormater.call(enriched_tor_exit_nodes)
    Tornados::FileWriter.call(csv_enriched_tor_exit_nodes, result_file_path)
    log
  end

  def log
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_info.log'))
    logger.tagged("TORNADOS (#{Time.now}):") do
      logger.info("Tor exit nodes file was created.")
    end
  end

  def max_mind_key
    ENV["TORNADOS_GEO_API_DATABASE_LICENSE_KEY"]
  end

  def exit_nodes_uri
    Tornados::NodesFetcher.default_url
  end

  def tornados_storage_path
    @tornados_storage_path ||= TornadosService.tornados_storage_path
  end

  def prepare_storage
    FileUtils.mkdir_p(tornados_storage_path)
  end

  def result_file_path
    TornadosSerivce.result_file_path
  end

  def filter_iso_codes
    return nil unless ENV['TORNADOS_ISO_CODES']
    ENV['TORNADOS_ISO_CODES'].split(',')
  end

  def filter
    return nil unless filter_iso_codes

    l = -> (checked_value) { filter_iso_codes.include?(checked_value) }
    Tornados::Filter.new(l) 
  end
end
