require_relative '20180407164519_create_ckeditor_assets.rb'

class RevertCkeEditorAssets < ActiveRecord::Migration[5.1]
  def change
    revert CreateCkeditorAssets
  end
end
