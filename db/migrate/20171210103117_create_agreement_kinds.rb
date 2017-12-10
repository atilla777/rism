class CreateAgreementKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :agreement_kinds do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :agreement_kinds, :name
  end
end
