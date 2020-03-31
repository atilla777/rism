class AddAuthTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :api_token, :string
    add_column :users, :api_user, :boolean

    add_index :users, :api_token
  end
end
