class AddProcessedAtToVulnerabilities < ActiveRecord::Migration[5.1]
  def change
    add_column :vulnerabilities, :processed_at, :datetime
  end
end
