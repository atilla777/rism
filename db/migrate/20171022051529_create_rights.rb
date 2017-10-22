class CreateRights < ActiveRecord::Migration[5.1]
  def change
    create_table :rights do |t|
      t.references :role, foreign_key: true
      t.references :subject, polymorphic: true
      t.integer :level
      t.boolean :inherit, null: false, default: true

      t.timestamps
    end
    add_index :rights, :level
    add_index :rights, :inherit
  end
end
