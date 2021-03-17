class ScanOption < ApplicationRecord

  QUEUE_NUMBERS = 1..2
  NMAP_OPT_MAP = {
    syn_scan: '-sS',
    skip_discovery: '-Pn',
    udp_scan: '-sU',
    service_scan: '-sV',
    os_fingerprint: '-O',
    aggressive_timing: '-T4',
    insane_timing: '-T5',
    disable_dns: '-n'
  }.freeze

  validates :name, length: { minimum: 3, maximum: 100 }
  validates :queue_number, length: { minimum: 1, maximum: 2 }
  validates :name, uniqueness: true

  has_many :scan_jobs, dependent: :restrict_with_error

  serialize :options, Hash
  store_accessor :options,
                 :syn_scan,
                 :skip_discovery,
                 :udp_scan,
                 :os_fingerprint,
                 :service_scan,
                 :top_ports,
                 :aggressive_timing,
                 :insane_timing,
                 :disable_dns,
                 :ports

  def self.queue_numbers
    QUEUE_NUMBERS
  end

  # For display nmap options as string
  def show_nmap_options
    opt = options.each_with_object([]) do |(opt_key, opt_value), memo|
      if opt_key == 'top_ports' && opt_value.present?
        memo << "--top-ports #{opt_value}"
      elsif opt_key == 'ports' && opt_value.present?
        memo << "-p #{ScanJob.normalize_ports_as_string(opt_value)}"
      elsif opt_value == '1' && NMAP_OPT_MAP[opt_key.to_sym]
        memo << NMAP_OPT_MAP[opt_key.to_sym]
      end
    end
    opt.join(' ')
  end
end
