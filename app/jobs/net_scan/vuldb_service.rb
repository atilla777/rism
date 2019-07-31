class NetScan::VuldbService
  require 'httparty'

  SERVICE_URL = 'https://vuldb.com/?api'.freeze
  SERVICE_NAME = 'Vuldb'.freeze

  def initialize(**options)
    @software = options.fetch(:software, nil)
    @version = options.fetch(:version, nil)
    @key = ENV['VULDB_KEY']
  end

  def run
    check_arguments
    response = request
    check_service_error(response)
    check_and_return_response(response)
  rescue StandardError => error
    handle_errors(error)
  end

  private

  def check_arguments
    raise ArgumentError, 'Software name should be present' if @software.nil?
    raise ArgumentError, 'Version should be present' if @version.nil?
  end

  def request
    search_string = "product:#{@software},version:#{@version}"
    request_params = {
        apikey: @key,
        advancedsearch: search_string
    }
    HTTParty.post(
      SERVICE_URL,
      options.merge(body: request_params)
    )
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

  def check_service_error(response)
    not_error = response.code == 200 || response.code == 204
    return true unless not_error
    parsed_response = JSON.parse(response.body)
    error = parsed_response.fetch('response', {}).fetch('error', '')
    status = parsed_response.fetch('response', {}).fetch('status', 0)
    return false if error.blank? || status.to_i == 204
    raise StandardError, "External IP service response error - #{error}"
  end

  def check_and_return_response(response)
    return {} if response.code == 204
    JSON.parse(response.body)
  end

  def handle_errors(error)
    log_error("Service #{SERVICE_NAME} cant` be used - #{error}", 'net_scan')
    {}
  end

  def log_error(error, tag)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("SCAN_JOB (#{Time.now}): #{tag}") do
      logger.error(error)
    end
  end
end
