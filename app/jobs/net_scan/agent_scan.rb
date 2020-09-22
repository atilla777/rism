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
    response = HTTParty.post(uri, httparty_options)
    result = JSON.parse(response.body)
    m = message(result)
    if response.code != 200 || result['message'] != 'accepted'
      raise StandardError.new "Aget don`t accept job: #{response.code} - #{m}"
    end
  rescue StandardError => error
     log_error("Agent error: #{error}")
     # TODO delete job from log
  end

  def message(result)
    if result['message'].present?
      result['message']
    elsif result['error'].present?
      result['error']
    else
      nil
    end
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
    host = if @agent.hostname.present?
              @agent.hostname
           else
              @agent.address
           end
    port = @agent.port
    protocol = @agent.protocol || 'http'
    path = 'scans'
    "#{protocol}://#{host}:#{port}/#{path}"
  end

  def http_request(uri)
    HTTParty.post(uri, httparty_options)
  rescue StandardError => error
    log_error("API can`t be used - #{error}")
    {httparty_error: error}
  end

  def httparty_options
    {}.merge(headers)
      .merge(proxy_options)
      .merge(data)
  end

  def headers
    {headers: {authorization: "Bearer #{@agent.secret}"}}
  end

  # Data sended in post form
  def data
    {query: {id: @jid, options: @job.nmap_options_string}}
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

  # Log httparty errors in file
  def log_error(error)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("AGENT_SCAN (#{Time.now})") do
      logger.error(error)
    end
  end
end
