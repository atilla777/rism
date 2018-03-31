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

  has_many :tags, dependent: :restrict_with_error

  def name_with_code
    TagKindDecorator.new(self).name_with_code
  end
end
