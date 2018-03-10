class LinkKind < ApplicationRecord
  validates :name, length: { in: 3..255 }
  validates :name, uniqueness: { scope: [:record_type] }
  validates :code_name, length: { in: 1..10 }
  validates :code_name, uniqueness: true
  validates :rank, numericality: { only_integer: true }
  validates :record_type, inclusion: { in: Link.record_types.keys }
  validates :equal, inclusion: { in: [true, false] }

  has_many :links
end
