class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.references :job, polymorphic: true
      t.integer :minutes, array: true, default: []
      t.integer :hours, array: true, default: []
      t.integer :month_days, array: true, default: []
      t.integer :months, array: true, default: []
      t.integer :week_days, array: true, default: []
      t.text :crontab_line

      t.timestamps
    end
  end
end
