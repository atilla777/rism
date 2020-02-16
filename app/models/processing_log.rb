class ProcessingLog < ApplicationRecord
  validates :delivery_subject_id,
            numericality: { only_integer: true }
  validates :organization_id,
            numericality: { only_integer: true }
  validates :processed_by_id,
            numericality: { only_integer: true }

  validates(
    :delivery_subject_id,
    uniqueness: { scope: [:organization_id]}
  )

  belongs_to :delivery_subject

  belongs_to :organization

  belongs_to :processor, foreign_key: :processed_by_id, class_name: 'User', optional: true

end
