class AddFieldsToHost < ActiveRecord::Migration[5.1]
  def change
    add_reference :hosts, :created_by, index: true, foreign_key: false
    add_reference :hosts, :updated_by, index: true, foreign_key: false
  end
end
