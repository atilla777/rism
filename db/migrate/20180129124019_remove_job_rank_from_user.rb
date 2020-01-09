class RemoveJobRankFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :job_rank, :integer
  end
end
