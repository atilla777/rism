class TagKind < ApplicationRecord
  def self.record_types
    Right.subject_types
  end

  include TagKind::Ransackers

  validates :name, length: { minimum: 1, maximum: 100 }
  validates :code_name, length: { minimum: 1, maximum: 10 }
  validates :name, uniqueness: true
  validates :code_name, uniqueness: true
  validates(
    :record_type,
    inclusion: { in: Link.record_types.keys, allow_blank: true }
  )
  validate :color, :css_hex

  has_many :tags, dependent: :restrict_with_error

  def name_with_code
    TagKindDecorator.new(self).name_with_code
  end

  private

  # TODO: make translation
  def css_hex
    return if color =~ /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i
    errors.add(:color, 'must be a valid CSS hex color code')
  end
end
