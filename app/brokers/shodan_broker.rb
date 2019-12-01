# frozen_string_literal: true

# Enrich IOCs from Shodan API
class ShodanBroker < BaseBroker
  BASE_URI = 'https://api.shodan.io/'.freeze

  INDICATORS_KINDS_MAP = {
    network: ['ip']
  }.freeze

  QUEUE = 'free_shodan_scan'.freeze

  HOST_NOT_FOUND_ERROR='No information available for that IP.'

  def set_custom_options(indicator_content, content_format)
     @api_key = ENV['SHODAN_KEY']
     @free_shodan_key = ENV['FREE_SHODAN']
     @indicator_content = indicator_content
  end

  def execute
    # Free key limit - 30 requests per 1 minute (2 sec on request)
    sleep(2) if @free_shodan_key.present?
    response = http_request(uri)
    check_and_return_http_response(response)
  rescue  => error
    handle_httparty_errors(error)
  end

  private

  def uri
    %W(
      #{BASE_URI}
      shodan/host/
      #{@indicator_content}
      ?key=#{@api_key}
    ).join
  end

  def error_log_tag
    'SHODAN'
  end

  def check_and_return_http_response(response)
    host_not_not_found = (response.fetch('error', '') != ShodanBroker::HOST_NOT_FOUND_ERROR)
    if response.code != 200 && host_not_not_found
      log_error("#{error_log_message} - #{response.code}")
    end
    JSON.parse(response.body)
  end
end
