class AddDepartmentIdToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :department, foreign_key: true
    add_column :users, :job_rank, :integer
    add_index :users, :job_rank
  end
end
