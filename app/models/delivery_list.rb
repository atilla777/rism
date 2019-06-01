class DeliveryList < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  belongs_to :organization

  validates :name, length: { minimum: 3, maximum: 250 }
  validates :name, uniqueness: { scope: :organization_id }
  validates :organization_id, numericality: { only_integer: true }
end
