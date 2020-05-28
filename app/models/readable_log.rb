# frozen_string_literal: true

class ReadableLog < ApplicationRecord
  validates :user_id, numericality: { only_integer: true }
  validates :readable_id, numericality: { only_integer: true }
  validates :user_id, uniqueness: { scope: [:readable_type, :readable_id] }
  validates :read_created_at, presence: true
  validates :read_updated_at, presence: true

  belongs_to :user
  belongs_to :readable, polymorphic: true
end
