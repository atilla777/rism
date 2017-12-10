class AgreementKind < ApplicationRecord
  validates :name, length: {minimum: 3, maximum: 100 }

  has_many :agreements
end
