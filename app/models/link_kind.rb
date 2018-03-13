# frozen_string_literal: true

class LinkKind < ApplicationRecord
  validates :name, length: { in: 3..255 }
  validates(
    :name,
    uniqueness: { scope: %i[first_record_type] }
  )
  validates :code_name, length: { in: 1..10 }
  validates :code_name, uniqueness: true
  validates :rank, numericality: { only_integer: true }
  validates(
    :first_record_type,
    inclusion: { in: Right.subject_types.keys, allow_blank: true }
  )
  validates :second_record_type, inclusion: { in: Right.subject_types.keys }
  validates :equal, inclusion: { in: [true, false] }

  has_many :links

  def self.allowed_to_record(record)
    where(first_record_type: record.class.name)
    .or(where(first_record_type: ''))
  end
end
