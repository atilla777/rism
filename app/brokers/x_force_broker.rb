# frozen_string_literal: true

# Enrich IOCs from IBM X-Force API
class XForceBroker < BaseBroker
  # Free key limit - 5 000 requests per mounth
  BASE_URI = 'https://api.xforce.ibmcloud.com'.freeze

  # Map RISM indicsator kinds on API services names
  # {rism_indicatir_kind: ['api_service1', 'ape_serviceN']}
  INDICATORS_KINDS_MAP = {
    md5: ['malware'],
    sha1: ['malware'],
    sha256: ['malware'],
    uri: ['resolve', 'url', 'url/malware'],
    domain: ['resolve', 'whois', 'url', 'url/malware'],
    network: ['resolve', 'whois', 'ipr', 'ipr/malware']
  }.freeze

  def set_custom_options(indicator_content, indicator_kind)
    @indicator_content = indicator_content
    @api_indicator_kinds = INDICATORS_KINDS_MAP[indicator_kind.to_sym]
  end

  def execute
    results = {}
    @api_indicator_kinds.each do |service|
      begin
        response = http_request(uri(service))
        results[service] = check_and_return_http_response(response)
      rescue  => error
        results = handle_httparty_errors(error)
      end
    end
    results
  end

  private

  def uri(service)
    %W(
      #{BASE_URI}/
      #{service}/
      #{@indicator_content}
     ).join
  end

  def basic_auth_key
    ENV['X_FORCE_KEY']
  end

  def basic_auth_secret
    ENV['X_FORCE_SECRET']
  end

  def error_log_tag
    'IBM_X_FORCE'
  end
end
