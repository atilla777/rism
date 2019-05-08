class CreateInvestigationKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :investigation_kinds do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
