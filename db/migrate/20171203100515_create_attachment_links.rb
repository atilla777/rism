class CreateAttachmentLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :attachment_links do |t|
      t.references :record, polymorphic: true
      t.references :attachment

      t.timestamps
    end
  end
end
