# frozen_string_literal: true

class InvestigationKind < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, length: { minimum: 1, maximum: 100 }

  has_many :investigations, dependent: :restrict_with_error
end
