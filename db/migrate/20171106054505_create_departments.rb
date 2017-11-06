class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments do |t|
      t.string :name
      t.references :organization, foreign_key: true
      t.references :parent, table: :departments, index: true
      t.text :description

      t.timestamps
    end
    add_foreign_key :departments, :departments, column: :parent_id
    add_index :departments, :name
  end
end
