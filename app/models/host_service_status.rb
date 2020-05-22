# frozen_string_literal: true

class HostServiceStatus < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, length: { minimum: 3, maximum: 200 }
  validates :rank, numericality: { only_integer: true, allow_blank: true }

  has_many :host_services, dependent: :restrict_with_error
end
