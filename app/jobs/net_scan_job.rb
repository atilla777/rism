class NetScanJob < ApplicationJob
  require 'nmap/program'
  require 'nmap/xml'

  queue_as do
    arg = self.arguments.second
    if arg == 'now'
      :now_scan
    else
      :scheduled_scan
    end
      :default
  end

  def perform(*args)
    job = ScanJob.find(args[0])

    job_start = DateTime.now

    # set XML result file path
    result_path = set_result_path(job, job_start)

    # sett ruby-nmap options
    scan_options = job.scan_option.options.select { |key, value| value.to_i.nonzero? }
    scan_options.update(scan_options) { |key, value| value = true if value == '1' }
    scan_options[:xml] = result_path
    scan_options[:targets] = job.hosts
    if job.ports.present?
      scan_options[:ports] = job.ports.split(',')
      scan_options[:ports] = scan_options[:ports].map do |port|
        if port.include?('-')
          Range.new(*port.split("-").map(&:to_i))
        else
          port.to_i
        end
      end
    end
    scan_options[:verbose] = true

    # scan and save result to XML file
    Nmap::Program.sudo_scan(scan_options)
    # save result from XML to database
    parse(job, job_start, result_path)
  end

  private

  # parse result_file_name and save to database
  def parse(job, job_start, result_path)
    Nmap::XML.new(result_path) do |xml|
      xml.each_host do |host|
        if host.ports.present?
          host.each_port do |port|
            # TODO: change it
            legality = HostService.legality(
              host.ip, port.number, port.protocol, port.state
            )
            save_to_database(
              scan_result_attributes(job, job_start, host, port, legality)
            )
          end
        else
          save_to_database(
            empty_scan_result_attributes(job, job_start, host, 0, :no_sense)
          )
        end
      end
    end
    File.delete(result_path)
  end

  def save_to_database(result_attributes)
    scan_result = ScanResult.create(result_attributes
      .merge(current_user: User.find(1))
    )
    scan_result.save!
  rescue ActiveRecord::RecordInvalid
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_erros.log"))
    logger.tagged("SCAN_JOB: #{scan_result}") do
      logger.error("scan result can`t be saved - #{scan_result.errors.full_messages}")
    end
  end

  def scan_result_attributes(job, job_start, host, port, legality)
    {
      job_start: job_start,
      start: host.start_time,
      finished: host.end_time,
      scan_job_id: job.id,
      organization_id: job.organization_id,
      ip: host.ip,
      port: port.number,
      protocol: port.protocol,
      state: port.state,
      legality: legality,
      service: port.service,
      product: port&.service&.product,
      product_version: port&.service&.version,
      product_extrainfo: port&.service&.extra_info
    }
  end

  def empty_scan_result_attributes(job, job_start, host, port, legality)
    {
      job_start: job_start,
      start: host.start_time,
      finished: host.end_time,
      scan_job_id: job.id,
      organization_id: job.organization_id,
      ip: host.ip,
      port: port,
      protocol: '',
      state: 0,
      legality: legality,
      service: '',
      product: '',
      product_version: '',
      product_extrainfo: ''
    }
  end

  def set_result_path(job, job_start)
    # path to XML file with nmap scan results
    result_folder = "tmp"
    # XML file name
    result_file = "#{job.id}_#{job_start.strftime("%Y.%m.%d-%H.%M.%S")}_nmap.xml"
    # full path to XML file
    "#{result_folder}/#{result_file}"
  end
end
