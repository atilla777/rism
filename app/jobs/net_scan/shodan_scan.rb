# frozen_string_literal: true

class NetScan::ShodanScan
  require 'httparty'
  require 'ipaddr'

  def initialize(job, jid)
    @job = job
    @jid = jid
    @job_start = DateTime.now
    @hosts = hosts_to_array(@job.targets)
  end

  def run
    save_result(fetch_result_from_shodan)
  end

  private

  def hosts_to_array(hosts_ranges)
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
      result = ShodanBroker.call(host, :network)
      if host_info_not_found?(result)
        memo << {no_host_info: host}
      elsif result['error'].blank?
        memo << result
      end
    end
  end

  def host_info_not_found?(response)
    return true if response.fetch('error', '') == ShodanBroker::HOST_NOT_FOUND_ERROR
    false
  end

  def log_error(error, tag)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("SCAN_JOB (#{Time.now}): #{tag}") do
      logger.error(error)
    end
  end

  # parse result_file_name and save to database
  def save_result(result)
    result.each do |host|
      if host[:no_host_info].present?
        save_to_database(
          empty_scan_result_attributes(host[:no_host_info])
        )
      elsif host['data'].present?
        host['data'].each do |service|
          next if service_info_not_present?(service)
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

  def service_info_not_present?(service)
    return true if service['port'].blank?
    return true if service['transport'].blank?
    return true if service['ip_str'].blank?
    false
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
      product_extrainfo: '',
      vulners: NetScan::FormatVulners.new(service, :shodan).format,
      jid: @jid
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
      product_extrainfo: '',
      vulners: [],
      jid: @jid
    }
  end
end
