class Organization < ApplicationRecord
  has_many :rights, as: :subject

#  has_many :organizations, foreign_key: :parent_id
#  belongs_to :parent, class_name: Organization

  validates :name, length: {minimum: 3, maximum: 100}
end
