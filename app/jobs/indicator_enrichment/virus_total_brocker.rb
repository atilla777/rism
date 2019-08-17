# frozen_string_literal: true

class IndicatorEnrichment::VirusTotalBrocker
  BASE_URI = 'https://www.virustotal.com/vtapi'.freeze

  API_VERSION = 2

  INDICATORS_KINDS_MAP = {
    md5: ['file', 'resuorce'],
    sha1: ['file', 'resuorce'],
    sha256: ['file', 'resuorce'],
    uri: ['url', 'resuorce'],
    domain: ['domain', 'domain'],
    network: ['ip-address', 'ip']
  }.freeze

  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(indicator_content, app_indicator_kind)
     @indicator_content = indicator_content
     @vt_indicator_kind = INDICATORS_KINDS_MAP[app_indicator_kind.to_sym]
     @api_key = ENV['VIRUS_TOTAL_PRIVATE_KEY'] || ENV['VIRUS_TOTAL_PUBLIC_KEY']
  end

  def execute
    # free shodan key limit - 4 request per 1 minute (15 sec on request)
    sleep(15) unless ENV['VIRUS_TOTAL_PRIVATE_KEY'].present?
    response = http_request(uri)
    check_and_return_http_response(response)
  rescue StandardError => error
    handle_httparty_errors(error)
  end

  private

  def uri
    "#{BASE_URI}/v#{API_VERSION}/#{@vt_indicator_kind[0]}/report?apikey=#{@api_key}&#{@vt_indicator_kind[1]}=#{@indicator_content}"
  end

  def http_request(uri)
    HTTParty.get(uri, httparty_options)
  end

  def httparty_options
    return {} if ENV['PROXY_SERVER'].blank?
    {
      verify: false,
      http_proxyaddr: ENV['PROXY_SERVER'],
      http_proxyport: ENV['PROXY_PORT'],
      http_proxyuser: ENV['PROXY_USER'],
      http_proxypass: ENV['PROXY_PASSWORD']
    }
  end

  def check_and_return_http_response(response)
    return {http_error: response.code} if response.code != 200
    JSON.parse(response.body)
  end

  def handle_httparty_errors(error)
    log_error("Service VirusTotal cant` be used - #{error}", 'virus_total')
    {httparty_error: error}
  end

  def log_error(error, tag)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("INDICATOR_ENRICHMENT (#{Time.now}): #{tag}") do
      logger.error(error)
    end
  end
end
