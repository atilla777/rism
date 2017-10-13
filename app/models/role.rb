class Role < ApplicationRecord
  has_many :role_members
  has_many :users, through: :role_members

  validates :name, length: { minimum: 3, maximum: 100}
end
