class Right < ApplicationRecord
  LEVELS = { 1 => I18n.t('rights.manager'),
             2 => I18n.t('rights.editor'),
             3 => I18n.t('rights.reader') }.freeze

  ACTIONS = { manage: 1,
              edit: 2,
              read: 3 }.freeze

  SUBJECT_TYPES = {'Organization' => Organization.model_name.human,
                   'User' => User.model_name.human,
                   'Department' => Department.model_name.human,
                   'Agreement' => Agreement.model_name.human,
                   'Attachment' => Attachment.model_name.human}.freeze


  validates :organization_id, numericality: { only_integer: true, allow_blank: true }
  validates :role_id, numericality: { only_integer: true }
  validates :subject_type, inclusion: { in: SUBJECT_TYPES.keys }
  validates :subject_id, numericality: { only_integer: true, allow_blank: true }
  validates :level, inclusion: { in: LEVELS.keys }

  validates :subject_id,
            uniqueness: { scope: [:role_id, :subject_type, :level] },
            allow_blank: true
  validates :subject_type,
            uniqueness: { scope: [:role_id, :subject_id, :level] },
            allow_blank: true,
            if: Proc.new { | r | r.subject_id.present? }
  validates :level, uniqueness: { scope: [:role_id, :subject_type, :subject_id] },
            unless: Proc.new { | r | r.subject_id.blank? }

  belongs_to :role
  belongs_to :subject, polymorphic: true, optional: true
  belongs_to :organization # organization has many right_scopes

  def show_subject_type
    SUBJECT_TYPES[subject_type]
  end

  def self.subject_types
    SUBJECT_TYPES
  end

  def show_level
    LEVELS[level]
  end

  def self.levels
    LEVELS
  end

  def self.action_to_level(action)
    ACTIONS[action]
  end
end
