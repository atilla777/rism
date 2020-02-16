class RemoveFieldsFromDeliverySubject < ActiveRecord::Migration[5.1]
  def change
    remove_column :delivery_subjects, :processed, :boolean
    remove_column :delivery_subjects, :processed_by_id, :integer
    remove_column :delivery_subjects, :recipient_comment, :text
  end
end
