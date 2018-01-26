# frozen_string_literal: true

class OrganizationKind < ApplicationRecord
  validates :name, length: { minimum: 1, maximum: 100 }
  validates :name, uniqueness: true

  has_many :organizations, dependent: :restrict_with_error
end
