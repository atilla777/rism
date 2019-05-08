# frozen_string_literal: true

class Right < ApplicationRecord
  include Right::Ransackers
  include Right::SubjectTypes

  validates :organization_id,
            numericality: { only_integer: true, allow_blank: true }
  validates :role_id, numericality: { only_integer: true }
  validates :subject_type, inclusion: { in: SUBJECT_TYPES.keys }
  validates :subject_id,
            numericality: { only_integer: true, allow_blank: true }
  validates :level, inclusion: { in: LEVELS.keys }

  # TODO: RSpec it
  validates :subject_id,
            uniqueness: { scope: [:role_id, :subject_type, :level] },
            allow_blank: true
  validates :subject_type,
            uniqueness: { scope: [:role_id, :subject_id, :level] },
            allow_blank: true,
            if: proc { |record| record.subject_id.present? }
  validates :level,
            uniqueness: { scope: [:role_id, :subject_type, :subject_id] },
            unless: proc { |r| r.subject_id.blank? }

  # Organization here is liake a security domain (scope)
  # (organization has many right_scopes)
  belongs_to :organization, optional: true

  # Role is an access subject
  belongs_to :role
  # Subject is an access subject
  belongs_to :subject, polymorphic: true, optional: true

  def self.subject_types
    SUBJECT_TYPES
  end

  def self.levels
    LEVELS
  end

  def self.action_to_level(action)
    ACTIONS[action]
  end

  def show_subject_type
    SUBJECT_TYPES[subject_type]
  end

  def show_level
    LEVELS[level]
  end
end
