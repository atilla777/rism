class RemoveVulnsFromScanResult < ActiveRecord::Migration[5.1]
  def change
    remove_column :scan_results, :vulns, :string
  end
end
