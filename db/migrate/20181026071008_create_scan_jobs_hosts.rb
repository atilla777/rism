class CreateScanJobsHosts < ActiveRecord::Migration[5.1]
  def change
    create_table :scan_jobs_hosts do |t|
      t.references :scan_job, foreign_key: true
      t.references :host, foreign_key: true

      t.timestamps
    end
  end
end
