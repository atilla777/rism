class CreateRecordTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :record_templates do |t|
      t.string :name
      t.string :record_content
      t.string :record_type
      t.text :description

      t.timestamps
    end
  end
end
