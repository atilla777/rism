class CreateUserActions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_actions do |t|
      t.references :user, foreign_key: true
      t.string :controller
      t.string :action
      t.jsonb :params
      t.cidr :ip
      t.string :browser
      t.integer :event, limit: 2
      t.string :record_model
      t.integer :record_id
      t.text :comment
      t.column :created_at, :datetime
    end
  end
end
