# frozen_string_literal: true

class PassiveTotalBrocker
  # https://api.passivetotal.org/v2/enrichment/malware?query=badguy.example.org
  BASE_URI = 'https://api.passivetotal.org'.freeze

  API_VERSION = 2

  # {rism_indicatir_type: 'api_type'}
  INDICATORS_KINDS_MAP = {
    md5: ['file', 'resource'],
    sha1: ['file', 'resource'],
    sha256: ['file', 'resource'],
    uri: ['url', 'resource'],
    domain: ['domain', 'domain'],
    network: ['ip-address', 'ip']
  }.freeze

  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(indicator_content, indicator_kind)
     @indicator_content = indicator_content
     @api_indicator_kind = INDICATORS_KINDS_MAP[indicator_kind.to_sym]
     @api_key = ENV['PASSIVE_TOTAL_KEY']
     @api_secret = ENV['PASSIVE_TOTAL_SECRET']
  end

  def execute
    # free key limit - X request per X minute (X sec on request)
    sleep(15) unless ENV['VIRUS_TOTAL_PRIVATE_KEY'].present?
    response = http_request(uri)
    check_and_return_http_response(response)
  rescue  => error
    handle_httparty_errors(error)
  end

  def self.format_supported?(format)
    INDICATORS_KINDS_MAP.fetch(format.to_sym, false)
  end

  private

  def auth
    {username: @api_key, password: @api_secret}
  end

  def uri
    # enrichment/malware?query=badguy.example.org
    #"#{BASE_URI}/v#{API_VERSION}/#{@service_indicator_kind[0]}/report?query=#{@indicator_content}"
    %W(
      #{BASE_URI}/
      v#{API_VERSION}/
      #{@service_indicator_kind[0]}?query=#{@indicator_content}"
     ).join
  end

  def http_request(uri)
    HTTParty.get(uri, httparty_options)
  end

  def httparty_options
    return {} if ENV['PROXY_SERVER'].blank?
    {
      verify: false,
      basic_auth: auth,
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
