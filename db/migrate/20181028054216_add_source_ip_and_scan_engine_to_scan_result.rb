class AddSourceIpAndScanEngineToScanResult < ActiveRecord::Migration[5.1]
  def change
    add_column :scan_results, :source_ip, :string
    add_column :scan_results, :scan_engine, :string
  end
end
