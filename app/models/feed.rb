class Feed < ApplicationRecord
  validates :name, length: { in: 3..100 }
end
