class TagMember < ApplicationRecord
  RECORD_TYPES = %w[
                   Organization
                   User
                   Department
                   Agreement
                   Incident
                   Host
                   RecordTemplate
                   Article
                   Investigation
                   Indicator
                 ]

  def self.record_types
    RECORD_TYPES
  end

  validates :record_id, numericality: { only_integer: true }
  validates :tag_id, numericality: { only_integer: true }
  validates :record_type, inclusion: { in: record_types }
  validates :tag_id, uniqueness: { scope: [:record_type, :record_id] }

  belongs_to :record, polymorphic: true
  belongs_to :tag
end
