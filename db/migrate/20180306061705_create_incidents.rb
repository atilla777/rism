class CreateIncidents < ActiveRecord::Migration[5.1]
  def change
    create_table :incidents do |t|
      t.string :name
      t.references :organization, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :user_id
      t.datetime :discovered_at
      t.boolean :discovered_time, default: false
      t.datetime :started_at
      t.boolean :started_time, default: false
      t.datetime :finished_at
      t.boolean :finished_time, default: false
      t.datetime :closed_at
      t.text :event_description
      t.text :investigation_description
      t.text :action_description
      t.integer :severity
      t.integer :damage
      t.integer :state

      t.timestamps
    end
  end
end
