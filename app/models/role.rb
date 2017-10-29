class Role < ApplicationRecord
  has_many :role_members
  has_many :users, through: :role_members

  has_many :rights

  validates :name, length: { minimum: 3, maximum: 100}
  validates :name, uniqueness: true
end
