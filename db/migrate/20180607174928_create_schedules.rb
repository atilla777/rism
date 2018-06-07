class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.references :job, polymorphic: true
      t.integer :hour
      t.integer :week_day
      t.integer :month_day

      t.timestamps
    end
  end
end
