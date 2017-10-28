class AddKindToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :kind, :integer
    add_index :organizations, :kind
  end
end
