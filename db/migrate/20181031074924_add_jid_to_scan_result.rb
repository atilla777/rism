class AddJidToScanResult < ActiveRecord::Migration[5.1]
  def change
    add_column :scan_results, :jid, :string
    add_index :scan_results, :jid
  end
end
