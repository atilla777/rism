class AddFieldsToRecordTemplate < ActiveRecord::Migration[5.1]
  def change
    add_reference :record_templates, :user, foreign_key: true
    add_reference :record_templates, :organization, foreign_key: true
  end
end
