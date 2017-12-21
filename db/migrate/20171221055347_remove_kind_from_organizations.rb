class RemoveKindFromOrganizations < ActiveRecord::Migration[5.1]
  def change
    remove_column :organizations, :kind, :integer
  end
end
