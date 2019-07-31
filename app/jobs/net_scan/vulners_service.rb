class NetScan::VulnersService
  require 'httparty'

  SERVICE_URL = 'https://vulners.com/api/v3/burp/software'.freeze
  SERVICE_NAME = 'Vulners'.freeze
  NOT_FOUND_MESSAGE = 'Nothing found for Burpsuite search request'.freeze

  def initialize(**options)
    @software = options.fetch(:software, nil)
    @version = options.fetch(:version, nil)
    @type = 'software'
  end

  def run
    # TODO: add argument error
    return {} if wrong_options?
    response = HTTParty.get(
      "#{SERVICE_URL}?software=#{@software}:&version=#{@version}&type=#{@type}",
      options
    )
    # TODO remove after debug
    puts response
    return {} if result_not_found?(response)
    raise 'External IP service response error' if service_error?(response)
    response
  rescue StandardError => err
    log_error("Service #{SERVICE_NAME} cant` be used - #{err}", 'net_scan')
    {}
  end

  private

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

  def wrong_options?
    return true if @software.nil?
    return true if @version.nil?
    false
  end

  def service_error?(response)
    return false if response.code == 200
    response.fetch('result', 'error') == 'OK'
  end

  def result_not_found?(response)
    message = response.fetch('data', {}).fetch('warning', '')
    return true if message = NOT_FOUND_MESSAGE
    false
  end

  def log_error(error, tag)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("SCAN_JOB (#{Time.now}): #{tag}") do
      logger.error(error)
    end
  end
end
