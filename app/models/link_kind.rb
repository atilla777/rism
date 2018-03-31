# frozen_string_literal: true

class LinkKind < ApplicationRecord
  def self.allowed_to_record(record)
    # TODO: make filter for template original record class
    return all if record.class.name == 'RecordTemplate'
    where(first_record_type: record.class.name)
    .or(where(first_record_type: ''))
  end

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
    inclusion: { in: Link.record_types.keys, allow_blank: true }
  )
  validates :second_record_type, inclusion: { in: Link.record_types.keys }
  validates :equal, inclusion: { in: [true, false] }

  validate :color, :css_hex

  has_many :links, dependent: :restrict_with_error

  private

  # TODO: make translation
  def css_hex
    return if color =~ /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i
    errors.add(:color, 'must be a valid CSS hex color code')
  end
end
