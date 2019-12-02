# frozen_string_literal: true

# Base Broker class for Internet services API
class BaseBroker
  BROCKERS = {
    virus_total: 'VirusTotalBroker',
    x_force: 'XForceBroker',
    shodan: 'ShodanBroker'
  }.freeze

  QUEUE = 'brokers'.freeze

  attr_reader :name, :queue

  def self.inherited(subclass)
    # Check that indicator content (IP, URL, etc) supported by service API
    # like this:
    # def self.format_supported?
    #   ...
    subclass.define_singleton_method (:format_supported?) do |format|
      subclass::INDICATORS_KINDS_MAP.fetch(format.to_sym, false)
    end
    # Queue in sidekiq
    # Redefine if you need custom queue
    # (for example, for limeted free service)
    subclass.define_singleton_method(:queue) do
      subclass::QUEUE
    end
  end

  def self.broker_name
    BROCKERS.detect do |_broker_name, broker_class|
      broker_class == self.name
    end.first.to_s
  end

  def self.brokers
    BROCKERS.values.map(&:constantize)
  end

  def self.useable_brokers(content_format)
    brokers.select do |broker|
      broker.format_supported?(content_format)
    end
  end

  def self.broker_by_name(name)
    BROCKERS[name.to_sym]
  end

  # Trick to make new object and run this one in one command (call)
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(*args)
     @verify_tls = if ENV['HTTPARTY_VERIFY_TLS']
                     ActiveModel::Type::Boolean.new.cast(
                       ENV['HTTPARTY_VERIFY_TLS']
                      )
                   else
                     true
                   end
     set_custom_options(*args)
  end

  # Redefine to set custom variables (like @api_time_limit and etc)
  def set_custom_options(*args); end

  # Run broker and get hash with arrays of API services responses
  # through #http_request and #check_and_return_http_response
  # Redefine this if you need
  def execute
    response = http_request(uri)
    check_and_return_http_response(response)
  end

  private

  # Cast request URI
  def uri
    raise 'Please, redefine me.'
  end

  def http_request(uri)
    HTTParty.get(uri, httparty_options)
  end

  def httparty_options
    {}.merge(basic_auth_options)
      .merge(proxy_options)
  end

  # Redefine use basic auth
  def basic_auth_key
    ENV['SOME_API_KEY'] ? ENV['SOME_API_KEY'] : nil
  end

  def basic_auth_secret
    ENV['SOME_API_SECRET'] ? ENV['SOME_API_SECRET'] : nil
  end

  def basic_auth_options
    return @basic_auth if @basic_auth
    @basic_auth = if basic_auth_key && basic_auth_secret
                    {basic_auth: {
                      username: basic_auth_key,
                      password: basic_auth_secret}
                    }
                  else
                    {}
                  end
    @basic_auth
  end

  def proxy_options
    return @proxy if @proxy
    @proxy = if ENV['PROXY_SERVER']
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
    @proxy
  end

  # Redefine if you need handle errors other than 400, 500 etc (not HTTP 200)
  def check_and_return_http_response(response)
    return {http_error: response.code} if response.code != 200
    JSON.parse(response.body)
  end

  # Log error in file and in #execute output
  def handle_httparty_errors(error)
    log_error("#{error_log_message} - #{error}")
    {httparty_error: error}
  end

  # Redefine to set API name
  def error_log_tag
    'API ERROR'
  end

  # Redefine if you need customize error message
  def error_log_message
    'API can`t be used'
  end

  # Log httparty errors in file
  def log_error(error)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("#{error_log_tag} (#{Time.now})") do
      logger.error(error)
    end
  end
end
