class CreateProcessingLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :processing_logs do |t|
      t.boolean :processed
      t.references :processable, polymorphic: true
      t.references :organization, foreign_key: true
      t.references :processed_by, index: true, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
