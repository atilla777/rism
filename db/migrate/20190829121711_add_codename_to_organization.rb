class AddCodenameToOrganization < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :codename, :string
  end
end
