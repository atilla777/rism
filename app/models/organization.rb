class Organization < ApplicationRecord
  paginates_per 5

  validates :name, length: {minimum: 3, maximum: 100}
end
