# frozen_string_literal: true

class NetScan::AgentScan
  require 'httparty'
  #require 'ipaddr'

  def initialize(job, jid)
    @job = job
    @jid = jid
    @agent = job.agent
    @job_start = DateTime.now
    @verify_tls = if ENV['HTTPARTY_VERIFY_TLS']
      ActiveModel::Type::Boolean.new.cast(ENV['HTTPARTY_VERIFY_TLS'])
    else
      true
    end
  end

  def run
    response = http_request(uri)
    #ScanJobLog.delete_log(:finish, job.id, jid, args[1] )
    check_and_return_http_response(response)
    # TODO log httparty error, delete log if error
  end

  private

  def log_error(error, tag)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("SCAN_JOB_ON_AGENT (#{Time.now}): #{tag}") do
      logger.error(error)
    end
  end

  # Cast request URI
  def uri
    host = @agent.hostname || @agent.address
    port = @agent.port
    protocol = @agent.protocol || 'http'
    path = 'scans'
    "#{protocol}://#{host}:#{port}/#{path}"
  end

  def http_request(uri)
    HTTParty.post(uri, httparty_options)
  rescue e
    log_error("API can`t be used - #{error}")
    {httparty_error: error}
  end

  def httparty_options
    {}.merge(headers)
      .merge(proxy_options)
      .merge(data)
  end

  def auth_options
    {headers: {uthorization: "Bearer #{@agent.secret}"}}
  end

  def data
    {query: {id: @jid, options: nmap_options}}
  end

  def nmap_options
    opt_map = {
      syn_scan: '-sS',
      skip_discovery: '-Pn',
      udp_scan: "-sU",
      service_scan: "-sS",
      os_fingerprint: "-O",
      aggressive_timing: "-T4",
      insane_timing: "-T5",
      disable_dns: "-n"
    }
    #TODO
#{"syn_scan"=>"1", "skip_discovery"=>"1", "udp_scan"=>"1", "service_scan"=>"0", "os_fingerprint"=>"0", "top_ports"=>"100", "aggressive_timing"=>"1", "insane_timing"=>"0", "disable_dns"=>"1", "ports"=>""}
    opt = @job.options.each_with_object(["#{job.hosts}"]) do |opt_key, opt_value, memo|
      if opt_key == "top_ports"
        memo << "#{--top-ports} #{opt_value}"
      elsif opt_key == "ports" && @job.ports.empty?
        memo << "#{-p} #{opt_value}"
      elsif opt_map[opt_key.to_sym].present?
        memo << opt_map[opt_key.to_sym]
      end

    end
    if @job.ports.present?
      opt << "-p #{@job.ports}"
    end
    opt.join(" ")
  end

  def proxy_options
    if ENV['RA_PROXY_SERVER']
      {
        verify: @verify_tls,
        http_proxyaddr: ENV['PROXY_SERVER'],
        http_proxyport: ENV['PROXY_PORT'],
        http_proxyuser: ENV['PROXY_USER'],
        http_proxypass: ENV['PROXY_PASSWORD']
      }
    else
      {}
    end
  end

  def check_and_return_http_response(response)
    return {http_error: response.code} if response.code != 200
    JSON.parse(response.body)
  end

  # Log httparty errors in file
  def log_error(error)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("AGENT_SCAN (#{Time.now})") do
      logger.error(error)
    end
  end
end
