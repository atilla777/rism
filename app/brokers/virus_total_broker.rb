# frozen_string_literal: true

# Enrich IOCs from VirusTotal API
class VirusTotalBroker < BaseBroker
  BASE_URI = 'https://www.virustotal.com/vtapi'.freeze

  API_VERSION = 2

  INDICATORS_KINDS_MAP = {
    md5: ['file', 'resource'],
    sha1: ['file', 'resource'],
    sha256: ['file', 'resource'],
    uri: ['url', 'resource'],
    domain: ['domain', 'domain'],
    network: ['ip-address', 'ip']
  }.freeze

  QUEUE = 'free_virus_total_broker'.freeze

  def set_custom_options(indicator_content, indicator_kind)
     @api_key = ENV['VIRUS_TOTAL_PRIVATE_KEY'] || ENV['VIRUS_TOTAL_PUBLIC_KEY']
     @vt_indicator_kind = INDICATORS_KINDS_MAP[indicator_kind.to_sym]
     @indicator_content = indicator_content
  end

  def execute
    # Free key limit - 4 request per 1 minute (15 sec on request)
    ENV['VIRUS_TOTAL_PRIVATE_KEY'].present?
    sleep(15) unless ENV['VIRUS_TOTAL_PRIVATE_KEY'].present?
    response = http_request(uri)
    check_and_return_http_response(response)
  rescue  => error
    handle_httparty_errors(error)
  end

  private

  def uri
    %W(
      #{BASE_URI}/
      v#{API_VERSION}/
      #{@vt_indicator_kind[0]}/
      report?apikey=#{@api_key}&
      #{@vt_indicator_kind[1]}=#{@indicator_content}
    ).join
  end

  def error_log_tag
    'VIRUS_TOTAL'
  end
end
