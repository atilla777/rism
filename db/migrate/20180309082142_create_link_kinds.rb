class CreateLinkKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :link_kinds do |t|
      t.string :name
      t.string :code_name
      t.integer :rank
      t.string :first_record_type
      t.string :second_record_type
      t.boolean :equal
      t.string :color
      t.text :description

      t.timestamps
    end
  end
end
