class CreateInvestigations < ActiveRecord::Migration[5.1]
  def change
    create_table :investigations do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.references :organization, foreign_key: true
      t.references :feed, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
