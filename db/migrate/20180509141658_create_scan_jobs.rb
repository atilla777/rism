class CreateScanJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :scan_jobs do |t|
      t.string :name
      t.references :organization, foreign_key: true
      t.string     :scan_engine
      t.references :scan_option, foreign_key: true
      t.string :hosts
      t.string :ports
      t.text :description

      t.timestamps
    end
  end
end
