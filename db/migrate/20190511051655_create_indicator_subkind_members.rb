class CreateIndicatorSubkindMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :indicator_subkind_members do |t|
      t.references :indicator, foreign_key: true
      t.references :indicator_subkind, foreign_key: true

      t.timestamps
    end
  end
end
