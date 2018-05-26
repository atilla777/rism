class CreateHostServices < ActiveRecord::Migration[5.1]
  def change
    create_table :host_services do |t|
      t.string :name
      t.references :organization, foreign_key: true
      t.references :host, foreign_key: true
      t.integer :port
      t.string :protocol
      t.integer :legality
      t.text :description

      t.timestamps
    end
    add_index :host_services, :port
  end
end
