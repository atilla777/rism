class CreateIndicatorContexts < ActiveRecord::Migration[5.1]
  def change
    create_table :indicator_contexts do |t|
      t.string  :name
      t.string  :codename
      t.text    :indicators_formats, array: true
      t.string  :description

      t.timestamps
    end
  end
end
