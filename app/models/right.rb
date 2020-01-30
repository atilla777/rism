# frozen_string_literal: true

class Right < ApplicationRecord
  include Right::Ransackers
  include Right::SubjectTypes

  ACTIONS = {
    manage: 1,
    edit: 2,
    read: 3
  }.freeze

  validates :organization_id,
            numericality: { only_integer: true, allow_blank: true }
  validates :role_id, numericality: { only_integer: true }
  validates :subject_type, inclusion: { in: SUBJECT_TYPES.keys }
  validates :subject_id,
            numericality: { only_integer: true, allow_blank: true }
  validates :level, inclusion: { in: LEVELS.keys }

  # TODO: RSpec it
  # Object here was wrong named as subject
  validates :subject_id,
            uniqueness: { scope: [:role_id, :subject_type, :level] },
            if: proc { |record| record.subject_id.present? && organization_id.blank? }
  validates :subject_type,
            uniqueness: { scope: [:role_id, :level] },
            if: proc { |record| record.subject_id.blank? && organization_id.blank? }
  validates :subject_id,
            uniqueness: { scope: [:role_id, :subject_type, :level, :organization_id] },
            if: proc { |record| record.subject_id.present? && organization_id.present? }
  validates :subject_type,
            uniqueness: { scope: [:role_id, :level, :organization_id] },
            if: proc { |record| record.subject_id.blank? && organization_id.present? }
#  validates :subject_type,
#            uniqueness: { scope: [:role_id, :subject_id, :level] },
#            allow_blank: true,
#            if: proc { |record| record.subject_id.present? }
#  validates :level,
#            uniqueness: { scope: [:role_id, :subject_type, :subject_id] },
#            unless: proc { |r| r.subject_id.blank? }

  # Organization here is like a security domain (scope)
  # (organization has many right_scopes)
  belongs_to :organization, optional: true

  # Role is an access subject
  belongs_to :role
  # Subject is an access object (yes, it was mistakly called such maner)
  #belongs_to :subject, polymorphic: true, optional: true

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
