class AddJidToScanResult < ActiveRecord::Migration[5.1]
  def change
    add_column :scan_results, :jid, :string
  end
end
