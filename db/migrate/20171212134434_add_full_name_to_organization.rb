class AddFullNameToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :full_name, :string
    add_index :organizations, :full_name
  end
end
