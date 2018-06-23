class NetScan::ShodanScan
  require 'httparty'
  require 'ipaddr'

  URL = 'https://api.shodan.io/'

  def initialize(job)
    @job = job
    @job_start = DateTime.now
    @hosts = hosts_to_array(@job.hosts)
    @key = ENV['SHODAN_KEY']
  end

  def run
    save_result(fetch_result_from_shodan)
  end

  private

  def hosts_to_array(hosts)
    hosts_ranges = hosts.split(',')
    result = hosts_ranges.each_with_object([]) do |hosts_range, memo|
      if hosts_range.include?('-')
        arr = hosts_range.split('-')
        first_ip = IPAddr.new(arr.first)
        last_ip = IPAddr.new(arr.last)
        memo = memo + (first_ip..last_ip).to_a
      else
        memo = memo.concat IPAddr.new(hosts_range).to_range.to_a
      end
    end
    result.map(&:to_s)
  end

  def fetch_result_from_shodan
    @hosts.each_with_object([]) do |host, memo|
      result = get(host)
      next if result[:error]
      if result[:no_host_info]
        memo << {no_host_info: host}
      else
        memo << result
      end
    end
  end

  def get(ip)
    begin
      response = HTTParty.get("#{URL}shodan/host/#{ip}?key=#{@key}")
      raise 'Shodan error' if response.code != '200'
      response.parsed_response
    rescue StandardError => err
      log_error("scan result can`t be fetched - #{err}", 'shodan')
      {error: err}
    end
  end

  def log_error(error, tag)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_erros.log"))
    logger.tagged("SCAN_JOB: #{tag}") do
      logger.error(error)
    end
  end

  # parse result_file_name and save to database
  def save_result(result)
    result.each do |host|
      if host[:no_host_info].presnet?
        save_to_database(
          empty_scan_result_attributes(host[:no_host_info])
        )
      else
        host['data'].each do |service|
          next unless service[:port]
          legality = HostService.legality(
            service['ip_str'], service['port'], service['transport'], 'open'
          )
          save_to_database(
            scan_result_attributes(service, legality)
          )
        end
      end
    end
  end

  def save_to_database(result_attributes)
    scan_result = ScanResult.create(result_attributes
      .merge(current_user: User.find(1))
    )
    scan_result.save!
  rescue ActiveRecord::RecordInvalid
    log_error(
      "scan result can`t be saved - #{scan_result.errors.full_messages}",
      scan_result
    )
  end

  def scan_result_attributes(service, legality)
    {
      job_start: @job_start,
      start: service['timestamp'],
      finished: service['timestamp'],
      scan_job_id: @job.id,
      ip: service['ip_str'],
      port: service['port'],
      protocol: service['transport'],
      state: 'open',
      legality: legality,
      service: '',
      product: '',
      product_version: '',
      product_extrainfo: ''
    }
  end

  def empty_scan_result_attributes(ip_str)
    {
      job_start: @job_start,
      start: @job_start,
      finished: @job_start,
      scan_job_id: @job.id,
      ip: ip_str,
      port: 0,
      protocol: '',
      state: 0,
      legality: 'no_sense',
      service: '',
      product: '',
      product_version: '',
      product_extrainfo: ''
    }
  end
end
