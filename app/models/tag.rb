class Tag < ApplicationRecord
  validates :name, length: { minimum: 1, maximum: 150 }
  validates :rank, numericality: { only_integer: true }
  validates :tag_kind_id, numericality: { only_integer: true }
  validates :name, uniqueness: { scope: :tag_kind_id }

  belongs_to :tag_kind
end
