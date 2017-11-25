class CreateAgreements < ActiveRecord::Migration[5.1]
  def change
    create_table :agreements do |t|
      t.date :beginning
      t.text :prop
      t.integer :duration
      t.boolean :prolongation
      t.references :organization, foreign_key: true
      t.references :contractor, table: :organizations, index: true
      t.text :description

      t.timestamps
    end
    add_foreign_key :agreements, :organizations, column: :contractor_id
    add_index :agreements, :beginning
    add_index :agreements, :prop
  end
end
