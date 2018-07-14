class AddVulnsToScanResult < ActiveRecord::Migration[5.1]
  def change
    add_column :scan_results, :vulns, :text
  end
end
