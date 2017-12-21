class CreateOrganizationKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_kinds do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :organization_kinds, :name
  end
end
