# frozen_string_literal: true

class NetScan::AgentScan
  require 'httparty'

  def initialize(job, jid)
    @job = job
    @jid = jid
    @agent = job.agent
    @job_start = DateTime.now
    @verify_tls = if ENV['RA_HTTPARTY_VERIFY_TLS']
      ActiveModel::Type::Boolean.new.cast(ENV['RA_HTTPARTY_VERIFY_TLS'])
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
    log_error("Send data to agent error: #{error}")
    raise
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
  # Cast request URI
  def uri
    host = @agent.hostname.presence || @agent.address
    port = @agent.port
    protocol = @agent.protocol || 'http'
    path = 'scans'
    "#{protocol}://#{host}:#{port}/#{path}"
  end

  def httparty_options
    {}.merge(headers)
      .merge(proxy_options)
      .merge(data)
      .merge(verify: @verify_tls)
  end

  def headers
    {headers: {authorization: "Bearer #{@agent.secret}"}}
  end

  # Data sent in post form
  def data
    {query: {id: @jid, options: @job.nmap_options_string}}
  end

  def proxy_options
    if ENV['RA_PROXY_SERVER']
      {
        http_proxyaddr: ENV['RA_PROXY_SERVER'],
        http_proxyport: ENV['RA_PROXY_PORT'],
        http_proxyuser: ENV['RA_PROXY_USER'],
        http_proxypass: ENV['RA_PROXY_PASSWORD']
      }
    else
      {}
    end
  end

  # Log httparty errors in file
  def log_error(error)
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
    logger.tagged("AGENT_SCAN (#{Time.now})") do
      logger.error(error)
    end
  end
end
