class Organization < ApplicationRecord
  KINDS = { 0 => I18n.t('organization_kinds.organization'),
            100 => I18n.t('organization_kinds.department'),
            200 => I18n.t('organization_kinds.folder') }.freeze

  has_many :rights, as: :subject

  has_many :children, foreign_key: :parent_id
  belongs_to :parent, class_name: Organization

  validates :name, length: {minimum: 3, maximum: 100}
  validates :parent_id, numericality: { only_integer: true }
  validates :kind, inclusion: { in: LEVELS.keys }

  scope companies, -> { where(kind: 0) }
  scope departments, -> { where(kind: 100) }
  scope folders, -> { where(kind: 200) }

  def show_kind
    KINDS[kind]
  end

  def kinds
    KINDS
  end
end
