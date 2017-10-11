class Role < ApplicationRecord
  has_many :users, through: :role_memberships

  validates :name, length: { minimum: 3, maximum: 100}
end
