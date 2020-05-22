class CreateHostServiceStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :host_service_statuses do |t|
      t.string :name
      t.integer :rank, limit: 2
      t.text :description

      t.timestamps
    end
  end
end
