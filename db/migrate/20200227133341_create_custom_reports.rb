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
      t.references :folder, foreign_key: {to_table: :custom_reports_folders}
      t.references :organization, foreign_key: true
      t.string :name
      t.text :description
      t.text :statement
      t.column :result_format, 'custom_report_format'

      t.timestamps
    end

    add_index :custom_reports, :name
  end
end
