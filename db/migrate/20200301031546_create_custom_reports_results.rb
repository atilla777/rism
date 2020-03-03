class CreateCustomReportsResults < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_reports_results do |t|
      t.references :custom_report, foreign_key: true
      t.string :result_path
      t.jsonb :variables

      t.timestamps
    end
  end
end
