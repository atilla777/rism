class CreateNotificationsLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications_logs do |t|
      t.references :user, foreign_key: true
      t.references :deliverable, polymorphic: true
      t.references :recipient, table: :users, index: true
      t.datetime :created_at
    end
  end
end
