class CreateIndicatorSubkinds < ActiveRecord::Migration[5.1]
  def change
    create_table :indicator_subkinds do |t|
      t.string  :name
      t.string  :codename
      t.text    :indicators_kinds, array: true
      t.string  :description

      t.timestamps
    end
  end
end
