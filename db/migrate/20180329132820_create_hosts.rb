class CreateHosts < ActiveRecord::Migration[5.1]
  def change
    create_table :hosts do |t|
      t.string :name
      t.references :organization, foreign_key: true
      t.cidr :ip
      t.text :description

      t.timestamps
    end

    add_index :hosts, :ip
  end
end
