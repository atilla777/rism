class ProcessingLog < ApplicationRecord
  PROCESSABLE_TYPES = %w[
    DeliverySubject
    ].freeze

  validates :processable_type, inclusion: { in: PROCESSABLE_TYPES}
  validates :processable_id,
            numericality: { only_integer: true }
  validates :organization_id,
            numericality: { only_integer: true }
  validates :processed_by_id,
            numericality: { only_integer: true }

  validates(
    :processable_type,
    uniqueness: { scope: [:processable_id, :organization_id]}
  )

  belongs_to :organization

  belongs_to :processor, foreign_key: :processed_by_id, class_name: 'User', optional: true

  belongs_to :processable, polymorphic: true
end
