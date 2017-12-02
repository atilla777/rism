PaperTrail.config.track_associations = false
PaperTrail.config.version_limit = 5

#module PaperTrail
#  class Version < ActiveRecord::Base
#    ransacker :id do
#      Arel.sql("to_char(item_id::BIGINT,'fm9999999999999999999999999999999999')")
#    end
#    ransacker :item_id do
#      Arel.sql("to_char(item_id::BIGINT,'fm9999999999999999999999999999999999')")
#    end
#  end
#end
