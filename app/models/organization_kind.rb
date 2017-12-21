class OrganizationKind < ApplicationRecord
  validates :name, length: {minimum: 3, maximum: 100 }

  has_many :organizations
end
