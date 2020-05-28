class AddIpConstraintToHost < ActiveRecord::Migration[5.1]
  def change
    remove_index :hosts, :ip
    add_index :hosts, :ip, unique: true
  end
end
