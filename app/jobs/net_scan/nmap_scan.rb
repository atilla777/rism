# frozen_string_literal: true

class NetScan::NmapScan
  require 'nmap/program'
  require 'nmap/xml'

  def initialize(job, jid)
    @job = job
    @jid = jid
    @job_start = DateTime.now
    # set XML result file path
    @result_path = set_result_path
    # set ruby-nmap options
    @scan_options = scan_options
  end

  def run
    # scan and save result to XML file
    unless Nmap::Program.sudo_scan(@scan_options)
      log_error('nmap program finished with status 1', 'nmap scan')
    end
    # save result from XML to database
    parse_and_save_result
  end

  private

  def scan_options
    result = @job.scan_option.options.select { |_key, value| value.to_i.nonzero? }
    ports = if @job.ports.present?
              ScanJob.normalize_ports_as_array(@job.ports)
            elsif result[:ports].present?
              ScanJob.normalize_ports_as_array(result[:ports])
            end
    top_ports = result[:top_ports] if result[:top_ports].present?
    result.update(result) do |key, value|
      value = true if value == '1'
    end
    result[:xml] = @result_path
    result[:targets] = @job.targets
    result[:verbose] = true
    result[:ports] = ports if ports.present?
    result[:top_ports] = top_ports.to_i if top_ports.present? && ports.blank?
    result
  end

  # parse result_file_name and save to database
  def parse_and_save_result
    Nmap::XML.new(@result_path) do |xml|
      xml.each_host do |host|
        if host.ports.present?
          host.each_port do |port|
            # TODO: change it
            legality = HostService.legality(
              host.ip, port.number, port.protocol, port.state
            )
            save_to_database(
              scan_result_attributes(host, port, legality)
            )
          end
        else
          save_to_database(
            empty_scan_result_attributes(host, 0, :no_sense)
          )
        end
      end
    end
    File.delete(@result_path)
  rescue StandardError => error
    log_error("scan result can`t be opened - #{error}", 'nmap scan')
  end

  def log_error(error, tag)
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("SCAN_JOB (#{Time.now}): #{tag}") do
      logger.error(error)
    end
  end

  def save_to_database(result_attributes)
    scan_result = ScanResult.create(
      result_attributes.merge(current_user: User.find(1))
    )
    scan_result.save!
  rescue ActiveRecord::RecordInvalid
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
    logger.tagged("SCAN_JOB: #{scan_result}") do
      logger.error("scan result can`t be saved - #{scan_result.errors.full_messages}")
    end
  end

  def scan_result_attributes(host, port, legality)
    vulners = check_vulners(port)
    {
      job_start: @job_start,
      start: host.start_time,
      finished: host.end_time,
      scan_job_id: @job.id,
      ip: host.ip,
      port: port.number,
      protocol: port.protocol,
      state: ScanResult.nmap_to_rism_port_state(port.state),
      legality: legality,
      service: port.service,
      product: port&.service&.product,
      product_version: port&.service&.version,
      product_extrainfo: port&.service&.extra_info,
      vulners: vulners,
      jid: @jid
    }
  end

  def empty_scan_result_attributes(host, port, legality)
    {
      job_start: @job_start,
      start: host.start_time,
      finished: host.end_time,
      scan_job_id: @job.id,
      ip: host.ip,
      port: port,
      protocol: '',
      state: 0,
      legality: legality,
      service: '',
      product: '',
      product_version: '',
      product_extrainfo: '',
      vulners: [],
      jid: @jid
    }
  end

  def set_result_path
    # path to XML file with nmap scan results
    result_folder = Rails.root.join('tmp', 'nmap')
    FileUtils.mkdir_p(result_folder) unless File.directory?(result_folder)
    # XML file name
    result_file = "#{@job.id}_#{@job_start.strftime('%Y.%m.%d-%H.%M.%6N')}_nmap.xml"
    # full path to XML file
    "#{result_folder}/#{result_file}"
  end

  def check_vulners(port)
    params_valid = port&.service&.product.blank? || port&.service&.version.blank?
    return [] if params_valid
    vulners = NetScan::VuldbService.new(
      software: port&.service&.product,
      version: port&.service&.version
    ).run
    NetScan::FormatVulners.new(vulners, :vuldb).format
  end
end
