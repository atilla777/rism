class AddOrganizationsToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_reference :organizations, :parent, table: :organizations, index: true
    add_foreign_key :organizations, :organizations, column: :parent_id
  end
end
