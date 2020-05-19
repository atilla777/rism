class CreateAttachedFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :attached_files do |t|
      t.string :name
      t.string :new_name
      t.references :filable, polymorphic: true
      t.datetime :created_at
    end
  end
end
