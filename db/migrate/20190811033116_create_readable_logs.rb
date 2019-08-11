class CreateReadableLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :readable_logs do |t|
      t.references :user, foreign_key: true
      t.references :readable, polymorphic: true
      t.datetime :read_created_at
      t.datetime :read_updated_at

      t.timestamps
    end
  end
end
