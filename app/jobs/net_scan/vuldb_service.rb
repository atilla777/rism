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
    # TODO remove after debug
    puts response
    check_service_error(response)
    check_and_return_response(response)
  rescue StandardError => error
    handle_errors(error)
  end

  private

  def check_arguments
    return raise ArgumentError, 'Softare name should be present' if @software.nil?
    return raise ArgumentError, 'Version should be present' if @version.nil?
  end

  def request
    search_string = "product:#{@software},version:#{@version}"
    request_params = {
        apikey: @key,
        advancedsearch: search_string
    }
    HTTParty.post(SERVICE_URL,  body: request_params)
  end

  def check_service_error(response)
    return false if response.code == 200 || response.code == 204
    raise 'External IP service response error' if service_error?(response)
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
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_erros.log"))
    logger.tagged("SCAN_JOB (#{Time.now}): #{tag}") do
      logger.error(error)
    end
  end
end
