class OrganizationKind < ApplicationRecord
  validates :name, length: {minimum: 1, maximum: 100 }
  validates :name, uniqueness: true

  has_many :organizations

  # TODO dont allow delete kind assigned to existing organization
end
