class AddFeedCodenameToInvestigation < ActiveRecord::Migration[5.1]
  def change
    add_column :investigations, :feed_codename, :string
  end
end
