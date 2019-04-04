class AddIocToIndicator < ActiveRecord::Migration[5.1]
  def change
    add_column :indicators, :danger, :boolean
  end
end
