class CreateLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :links do |t|
      t.references :first_record, polymorphic: true
      t.references :second_record, polymorphic: true
      t.references :link_kind, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
