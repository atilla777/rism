class CreateTagMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_members do |t|
      t.references :record, polymorphic: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
