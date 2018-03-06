class Tag < ApplicationRecord
  validates :name, length: { minimum: 1, maximum: 150 }
  validates :rank, numericality: { only_integer: true }
  validates :tag_kind_id, numericality: { only_integer: true }
  validates :name, uniqueness: { scope: :tag_kind_id }

  belongs_to :tag_kind

  has_many :tag_members, dependent: :destroy
  has_many :agreements, through: :tag_members
  has_many :incidents, through: :tag_members
end
