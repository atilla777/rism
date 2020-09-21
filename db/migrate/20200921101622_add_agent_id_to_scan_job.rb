class AddAgentIdToScanJob < ActiveRecord::Migration[5.1]
  def change
    add_reference :scan_jobs, :agent, foreign_key: true
  end
end
