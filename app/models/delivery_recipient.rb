# frozen_string_literal: true

class DeliveryRecipient < ApplicationRecord
  RECIPIENTABLE_TYPES = %w[
    User
    Organization
  ].freeze

  def self.recipientable_types
   RECIPIENTABLE_TYPES
  end

  validates :recipientable_id,
            numericality: {only_integer: true}

  validates :recipientable_type, inclusion: {in: recipientable_types}

  validates :delivery_list_id,
            numericality: {only_integer: true}

  validates(
    :delivery_list_id,
    uniqueness: {scope: [:recipientable_type, :recipientable_id]}
  )

  belongs_to :recipientable, polymorphic: true
  belongs_to :delivery_list
  has_many :delivery_subjects, through: :delivery_list

  belongs_to :user, foreign_key: :created_by_id, class_name: 'User', optional: true
end
