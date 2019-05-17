class ResetVulnsJob < ApplicationJob
  require 'zlib'

  NVD_JSON_VERSION = '1.0'.freeze
  NVD_START_YEAR = 2002
  NVD_BASE_PATH = "https://nvd.nist.gov/feeds/json/cve/#{NVD_JSON_VERSION}/".freeze

  Sidekiq.default_worker_options = { 'retry' => 2 }

  queue_as do
    arg = self.arguments.second
    if arg.present?
      arg.to_sym
    else
      :default
    end
  end

  def perform(*args)
    (NVD_START_YEAR..Time.current.year).each do |year|
      download_gz_file(uri(year), gz_save_path(year))
      extract_gz_file(gz_save_path(year), year)
      parse_file(year)
      delete_files(year)
    end
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

  def parse_file(f)
  end

  def delete_files(f)
  end
end
