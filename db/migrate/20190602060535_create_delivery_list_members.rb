class CreateDeliveryListMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_list_members do |t|
      t.references :organization, foreign_key: true
      t.references :delivery_list, foreign_key: true

      t.timestamps
    end
  end
end
