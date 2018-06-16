class CreateScanResults < ActiveRecord::Migration[5.1]
  def change
    create_table :scan_results do |t|
      t.references :scan_job, foreign_key: true
      t.datetime :job_start
      t.datetime :start
      t.datetime :finished
      t.string   :scanned_ports
      t.cidr     :ip
      t.integer  :port
      t.string   :protocol
      t.integer  :state
      t.string   :service
      t.integer  :legality
      t.string   :product
      t.string   :product_version
      t.string   :product_extrainfo

      t.timestamps
    end
    add_index :scan_results, :port
    add_index :scan_results, :service
    add_index :scan_results, :product
  end
end
