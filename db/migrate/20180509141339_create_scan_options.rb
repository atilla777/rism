class CreateScanOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :scan_options do |t|
      t.string :name
      t.jsonb :options
      t.text :description

      t.timestamps
    end
  end
end
