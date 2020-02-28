class CreateCustomReports < ActiveRecord::Migration[5.1]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          CREATE TYPE custom_report_format
          AS ENUM (
            'csv', 'json'
          );
        SQL
      end

      change.down do
        execute <<-SQL
          DROP TYPE custom_report_format;
        SQL
      end
    end

    create_table :custom_reports do |t|
      t.references :custom_reports_folder, foreign_key: true
      t.references :organization, foreign_key: true
      t.references :user, foreign_key: true
      t.string :name
      t.text :description
      t.text :statement
      t.jsonb :variables
      t.column :result_format, 'custom_report_format'

      t.timestamps
    end

    add_index :custom_reports, :name
  end
end
