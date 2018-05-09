class ScanOption < ApplicationRecord
  validates :name, length: { minimum: 3, maximum: 100 }
  validates :name, uniqueness: true

  has_many :scan_jobs

  serialize :options#, HashSerializer
  store_accessor :options,
                 :syn_scan,
                 :skip_discovery,
                 :udp_scan,
                 :os_fingerprint,
                 :service_scan,
                 :top_ports,
                 :aggressive_timing,
                 :insane_timing,
                 :disable_dns
end
