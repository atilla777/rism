class AddDepartmentNameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :department_name, :string
  end
end
