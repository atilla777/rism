class ChangeDeliveryRecipients < ActiveRecord::Migration[5.1]
  def change
    remove_column :delivery_recipients, :organization_id, :integer
    add_reference(
      :delivery_recipients,
      :recipientable,
      polymorphic: true,
      index: { name: 'index_delvery_recipients_on_r_type_and_r_id' }
    )
  end
end
