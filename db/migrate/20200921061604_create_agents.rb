class CreateAgents < ActiveRecord::Migration[5.1]
  def change
    create_table :agents do |t|
      t.references :organization, foreign_key: true
      t.string :name
      t.cidr :address
      t.string :hostname
      t.string :port
      t.string :secret
      t.text :description

      t.timestamps
    end
  end
end
