class ScanJob < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  SCAN_ENGINES = %w[nmap shodan]

  has_paper_trail

  attr_accessor :add_organization_hosts

  after_save :link_organization_hosts

  validates :name, length: { minimum: 3, maximum: 100 }
  validates :name, uniqueness: { scope: :organization_id }
  validates :scan_option_id, numericality: { only_integer: true }
  validates :agent_id, numericality: { only_integer: true, allow_blank: true }

  belongs_to :scan_option

  has_one :schedule, as: :job, dependent: :destroy

  has_many :scan_results, dependent: :delete_all

  has_many :scan_jobs_hosts, dependent: :delete_all
  has_many :linked_hosts, through: :scan_jobs_hosts, source: :host

  has_many :scan_job_logs, dependent: :delete_all

  belongs_to :agent, optional: true

  def self.scan_engines
    SCAN_ENGINES
  end

  def worker
    'NetScanJob'
  end

  def job_queue(queue = 'scheduled_scan')
    if scan_engine == 'shodan' && ENV['FREE_SHODAN'] == 'true'
      'free_shodan_scan'
    else
      "#{queue}_#{scan_option.queue_number}"
    end
  end

  def targets
    hosts_from_scan_job = hosts.split(',').map(&:strip)
    hosts_from_scan_job | linked_hosts.pluck(:ip).map(&:to_s)
  end

  # For send nmap options to nmap as string
  def nmap_options_string
    h = targets.join(' ')
    opt = scan_option.options.each_with_object([h.to_s]) do |(opt_key, opt_value), memo|
      if opt_key == 'top_ports' && opt_value.present?
        memo << "--top-ports #{opt_value}"
      elsif opt_key == 'ports' && opt_value.present? && ports.empty?
        memo << "-p #{ScanJob.normalize_ports_as_string(opt_value)}"
      elsif opt_value == '1' && ScanOption::NMAP_OPT_MAP[opt_key.to_sym]
        memo << ScanOption::NMAP_OPT_MAP[opt_key.to_sym]
      end
    end
    opt << "-p #{ScanJob.normalize_ports_as_string(ports)}" if ports.present?
    opt.join(' ')
  end

  def self.normalize_ports_as_array(ports)
    ports.split(',').map do |port|
      if port.include?('-')
        Range.new(*port.split('-').map(&:to_i))
      else
        port.to_i
      end
    end
  end

  def self.normalize_ports_as_string(ports)
    ports.delete(' ')
  end

  private

  def link_organization_hosts
    return if add_organization_hosts != '1'
    organization.hosts.each do |host|
      scan_jobs_host = ScanJobsHost.new(
        host_id: host.id,
        scan_job_id: id
      )
      scan_jobs_host.save
    end
  end
end
