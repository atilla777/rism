class AddQueueNumberToScanOptions < ActiveRecord::Migration[5.1]
  def change
    add_column :scan_options, :queue_number, :integer
  end
end
