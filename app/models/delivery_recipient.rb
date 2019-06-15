class DeliveryRecipient < ApplicationRecord
  validates :organization_id,
            numericality: { only_integer: true }

  validates :delivery_list_id,
            numericality: { only_integer: true }

  validates(
    :delivery_list_id,
    uniqueness: { scope: :organization_id}
  )

  belongs_to :organization
  belongs_to :delivery_list
end
