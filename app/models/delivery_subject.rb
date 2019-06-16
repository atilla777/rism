class DeliverySubject < ApplicationRecord
  SUBJECT_TYPES = %w[
      Investigation
      Vulnerability
    ].freeze

  attr_accessor :current_user

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

  belongs_to :processor, foreign_key: :processed_by_id, class_name: 'User', optional: true
end
