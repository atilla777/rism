# frozen_string_literal: true

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
  has_many :delivery_recipients, dependent: :delete_all
  has_many(
    :users,
    through: :delivery_recipients,
    source: :recipientable,
    source_type: 'User'
  )
  has_many(
    :organizations,
    through: :delivery_recipients,
    source: :recipientable,
    source_type: 'Organization'
  )
end
