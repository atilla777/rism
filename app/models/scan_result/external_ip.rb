class ScanResult::ExternalIP
  require 'httparty'

  SERVICE_URL = 'https://api.myip.com'.freeze

  def run
    response = HTTParty.get(SERVICE_URL)
    raise 'External IP service response error' if service_error?(response)
    JSON.parse(response.parsed_response)['ip']
  rescue StandardError => err
    log_error("external IP can`t be fetched - #{err}", 'net_scan')
    ''
  end

  def service_error?(response)
    return false if response.code == 200
    true
  end

  def log_error(error, tag)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_erros.log"))
    logger.tagged("SCAN_JOB (#{Time.now}): #{tag}") do
      logger.error(error)
    end
  end
end
