class AddUtfEncodingToCustomReport < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_reports, :utf_encoding, :boolean
  end
end
