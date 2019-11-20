# frozen_string_literal: true

class XForceBrocker
  # Free key limit - 5 000 requests per mounth
  BASE_URI = 'https://api.xforce.ibmcloud.com'.freeze

  # Map RISM indicsator kinds on API services names
  # {rism_indicatir_kind: ['api_service1', 'ape_serviceN']}
  INDICATORS_KINDS_MAP = {
    md5: ['', ''],
    sha1: ['', ''],
    sha256: ['', ''],
    uri: ['', ''],
    domain: ['', ''],
    network: ['resolve', 'malware']
  }.freeze

  # Trick to make new object and run tem in one command (call)
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(indicator_content, indicator_kind)
     @indicator_content = indicator_content
     @api_indicator_kinds = INDICATORS_KINDS_MAP[indicator_kind.to_sym]
     @api_key = ENV['X_FORCE_KEY']
     @api_secret = ENV['X_FORCE_SECRET']

     # TODO move this value to ENV
     # False if tls cert was replaced by DLP
     @verify_tls = false
  end

  # Run broker and get hash with arrays of API services reponses
  def execute
    results = {}
    @api_indicator_kinds.each do |service|
      begin
        response = http_request(uri(service))
        results[service] = check_and_return_http_response(response)
      rescue  => error
        handle_httparty_errors(error)
      end
    end
    results
  end

  # Check tah indicator content (IP, URL, etc) supported by service API
  def self.format_supported?(format)
    INDICATORS_KINDS_MAP.fetch(format.to_sym, false)
  end

  private

  def auth
    {username: @api_key, password: @api_secret}
  end

  def uri(service)
    #xfti/anonsvcs/ipv4
    %W(
      #{BASE_URI}/
      #{service}/
      #{@indicator_content}
     ).join
  end

  def http_request(uri)
    HTTParty.get(uri, httparty_options)
  end

  def httparty_options
    return {} if ENV['PROXY_SERVER'].blank?
    {
      verify: @verify_tls,
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
    log_error("Service X Force cant` be used - #{error}", 'x_force')
    {httparty_error: error}
  end

  def log_error(error, tag)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("INDICATOR_ENRICHMENT (#{Time.now}): #{tag}") do
      logger.error(error)
    end
  end
end
