class ScanOption < ApplicationRecord
  validates :name, length: { minimum: 3, maximum: 100 }
  validates :name, uniqueness: true

  has_many :scan_jobs

  serialize :options, Hash#, HashSerializer
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


# Used in ScanOptions to serilize options
# (it makes allow acces to serialized field by symbol,
# not only string key)
#class HashSerializer
#  def self.dump(hash)
#    hash.to_json
#  end
#
#  def self.load(hash)
#    (hash || {}).with_indifferent_access
#  end
#end
end
