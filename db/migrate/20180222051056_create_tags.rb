class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.references :tag_kind, foreign_key: true
      t.integer :rank
      t.string :color
      t.text :description

      t.timestamps
    end
    add_index :tags, :name
  end
end
