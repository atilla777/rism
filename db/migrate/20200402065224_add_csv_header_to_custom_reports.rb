class AddCsvHeaderToCustomReports < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_reports, :add_csv_header, :boolean
  end
end
