class CreateScanJobLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :scan_job_logs do |t|
      t.references :scan_job, foreign_key: true
      t.string :jid
      t.string :queue
      t.datetime :start
      t.datetime :finish

      t.timestamps
    end
  end
end
