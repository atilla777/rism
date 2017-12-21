class AgreementKind < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, length: {minimum: 1, maximum: 100 }

  has_many :agreements
end
