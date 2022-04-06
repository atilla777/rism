# frozen_string_literal: true

class TaskStatus < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, length: { minimum: 1, maximum: 100 }
  validates :rank, numericality: { only_integer: true }
  validates :rank, uniqueness: true

  has_many :tasks, dependent: :restrict_with_error
end
