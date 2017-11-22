class AddRankToDepartment < ActiveRecord::Migration[5.1]
  def change
    add_column :departments, :rank, :integer
  end
end
