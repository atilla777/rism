class CreateTagKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_kinds do |t|
      t.string :name
      t.string :code_name
      t.string :record_type
      t.text :description

      t.timestamps
    end
    add_index :tag_kinds, :name
    add_index :tag_kinds, :code_name
  end
end
