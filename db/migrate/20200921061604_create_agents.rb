class CreateAgents < ActiveRecord::Migration[5.1]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          CREATE TYPE net_protocol
          AS ENUM (
            'http', 'https'
          )
        SQL
      end

      change.down do
        execute <<-SQL
          DROP TYPE net_protocol;
        SQL
      end
    end

    create_table :agents do |t|
      t.references :organization, foreign_key: true
      t.string :name
      t.cidr :address
      t.string :hostname
      t.column :protocol, 'net_protocol'
      t.string :port
      t.string :secret
      t.text :description

      t.timestamps
    end
  end
end
