class CreateDeliverySubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_subjects do |t|
      t.references :deliverable, polymorphic: true
      t.references :delivery_list, foreign_key: true
      t.boolean :processed, default: false
      t.references :processed_by,  index: true, foreign_key: {to_table: :users}
      t.boolean :answerable, default: false
      t.text :recipient_comment
      t.datetime :sent_at

      t.references :created_by,  index: true, foreign_key: {to_table: :users}
      t.references :updated_by,  index: true, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
