class CreateDeliveryLists < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_lists do |t|
      t.string :name
      t.references :organization, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
