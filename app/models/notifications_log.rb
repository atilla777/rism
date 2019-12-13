# frozen_string_literal: true

class NotificationsLog < ApplicationRecord
  belongs_to :user
  belongs_to :recipient,
    foreign_key: :recipient_id,
    class_name: 'User'
  belongs_to :deliverable, polymorphic: true

  validates :deliverable_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :recipient_id, numericality: { only_integer: true }
end
