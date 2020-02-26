# frozen_string_literal: true

class DeliverySubject < ApplicationRecord
  include Readable

  SUBJECT_TYPES = %w[
      Investigation
      VulnerabilityBulletin
      Article
    ].freeze

  attr_accessor :current_user

  validates :deliverable_type, inclusion: { in: SUBJECT_TYPES }
  validates :deliverable_id,
            numericality: { only_integer: true }

  validates :delivery_list_id,
            numericality: { only_integer: true }

  validates(
    :delivery_list_id,
    uniqueness: { scope: [:deliverable_type, :deliverable_id]}
  )

  belongs_to :deliverable, polymorphic: true

  belongs_to :delivery_list
  has_many :delivery_recipients, through: :delivery_list

  belongs_to :processor, foreign_key: :processed_by_id, class_name: 'User', optional: true

  has_many :processing_log, as: :processable, dependent: :delete_all
end
