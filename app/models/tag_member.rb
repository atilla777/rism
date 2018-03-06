class TagMember < ApplicationRecord
  RECORD_TYPES = %w[Agreement
                    Incident]

  validates :record_id, numericality: { only_integer: true }
  validates :tag_id, numericality: { only_integer: true }
  validates :record_type, inclusion: { in: RECORD_TYPES }
  validates :tag_id, uniqueness: { scope: [:record_type, :record_id] }

  belongs_to :record, polymorphic: true
  belongs_to :tag

  def self.record_types
    RECORD_TYPES
  end
end
