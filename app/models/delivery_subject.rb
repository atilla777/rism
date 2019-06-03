class DeliverySubject < ApplicationRecord
  SUBJECT_TYPES = %w[
      Investigation
      Vulnerability
    ].freeze

  validates :deliverable_type, inclusion: { in: SUBJECT_TYPES }
  validates :deliverable_id,
            numericality: { only_integer: true }

  validates :delivery_list_id,
            numericality: { only_integer: true }

  validates(
    :delivery_list_id,
    uniqueness: { scope: [:deliverable_type, :deliverable_id]}
  )

  belongs_to :deliverable, polymorphic: true
  belongs_to :delivery_list
end
