class CreateCustomReportsFolders < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_reports_folders do |t|
      t.string :name
      t.integer :rank
      t.text :description
      t.references :organization, foreign_key: true
      t.references :parent, table: :custom_report_folders, index: true

      t.timestamps
    end

    add_foreign_key :custom_reports_folders, :custom_reports_folders, column: :parent_id
    add_index :custom_reports_folders, :name
  end
end
