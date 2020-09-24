class AddAgentToScanJobLog < ActiveRecord::Migration[5.1]
  def change
    add_reference :scan_job_logs, :agent, foreign_key: true
  end
end
