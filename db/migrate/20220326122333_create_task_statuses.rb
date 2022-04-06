class CreateTaskStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :task_statuses do |t|
      t.integer :rank
      t.string :name

      t.timestamps
    end
  end
end
