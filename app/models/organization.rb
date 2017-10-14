class Organization < ApplicationRecord
  validates :name, length: {minimum: 3, maximum: 100}
end
