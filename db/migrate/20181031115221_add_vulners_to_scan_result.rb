class AddVulnersToScanResult < ActiveRecord::Migration[5.1]
  def change
    add_column :scan_results, :vulners, :jsonb, null: false, default: []
    add_index  :scan_results, :vulners, using: :gin
  end
end
