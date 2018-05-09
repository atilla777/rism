# Used in ScanOptions to serilize options
# (it makes allow acces to serialized field by symbol,
# not only string key)
class HashSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(hash)
    (hash || {}).with_indifferent_access
  end
end
