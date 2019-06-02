class CreateDeliverySubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_subjects do |t|
      t.references :deliverable, polymorphic: true
      t.references :delivery_list, foreign_key: true
      t.datetime :sent_at
      t.datetime :sent_at

      t.timestamps
    end
  end
end
