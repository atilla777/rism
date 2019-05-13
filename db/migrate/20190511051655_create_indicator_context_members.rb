class CreateIndicatorContextMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :indicator_context_members do |t|
      t.references :indicator, foreign_key: true
      t.references :indicator_context, foreign_key: true

      t.timestamps
    end
  end
end
