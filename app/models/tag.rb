class Tag < ApplicationRecord
  validates :name, length: { minimum: 1, maximum: 150 }
  validates :rank, numericality: { only_integer: true }
  validates :tag_kind_id, numericality: { only_integer: true }
  validates :name, uniqueness: { scope: :tag_kind_id }

  belongs_to :tag_kind

  has_many :tag_members, dependent: :destroy
  has_many :agreements, through: :tag_members
  has_many :incidents, through: :tag_members

  def self.record_types
    Right.subject_types
  end

  def self.allowed_to_record(record)
    where(tag_kinds: { record_type: record.class.name })
    .or(where(tag_kinds: { record_type: '' }))
    .joins(:tag_kind)
  end

  private

  # TODO: make translation
  def css_hex
    return if color =~ /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i
    errors.add(:color, 'must be a valid CSS hex color code')
  end
end
