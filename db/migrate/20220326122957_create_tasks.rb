class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.references :parent, foreign_key: {to_table: :tasks}
      t.string :name
      t.text :description
      t.text :current_description
      t.text :user_description
      t.date :start
      t.date :planned_end
      t.date :real_end
      t.string :task_tags, array: true, default: []
      t.references :task_priority, foreign_key: true
      t.references :task_status, foreign_key: true
      t.references :user, foreign_key: true
      t.references :organization, foreign_key: true

      t.references :created_by,  index: true, foreign_key: false
      t.references :updated_by,  index: true, foreign_key: false

      t.timestamps
    end

    add_index :tasks, :task_tags, using: 'gin'
  end
end
