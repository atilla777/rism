class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.references :organization, foreign_key: true
      t.string :name
      t.string :document

      t.timestamps
    end
    add_index :attachments, :name
  end
end
