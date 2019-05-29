class CreateCustomFields < ActiveRecord::Migration[5.1]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          CREATE TYPE custom_field_data_type
          AS ENUM ('string', 'text', 'datetime', 'number', 'boolean');
        SQL
      end

      change.down do
        execute <<-SQL
          DROP TYPE custom_field_data_type;
        SQL
      end
    end

    create_table :custom_fields do |t|
      t.string :name
      t.column :data_type, 'custom_field_data_type'
      t.string :field_model
      t.text :description

      t.timestamps
    end
  end
end
