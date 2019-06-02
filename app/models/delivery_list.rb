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

  has_many :delivery_subjects, dependent: :delete_all
  has_many :delivery_lists, through: :delivery_subjects

  has_many :delivery_list_members, dependent: :delete_all
  has_many :organizations, through: :delivery_list_members
end
