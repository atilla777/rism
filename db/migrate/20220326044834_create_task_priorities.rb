class CreateTaskPriorities < ActiveRecord::Migration[5.1]
  def change
    create_table :task_priorities do |t|
      t.string :name
      t.string :priority
      t.integer :rank

      t.timestamps
    end
  end
end
