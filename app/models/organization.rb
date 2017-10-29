class Organization < ApplicationRecord
  include OrganizationMember

  KINDS = { 0 => I18n.t('organization_kinds.organization'),
            100 => I18n.t('organization_kinds.department'),
            200 => I18n.t('organization_kinds.folder') }.freeze

  has_many :rights

  has_many :children, foreign_key: :parent_id
  belongs_to :parent, class_name: 'Organization', optional: true

  validates :name, length: {minimum: 3, maximum: 100}
  validates :name, uniqueness: true
  validates :parent_id, numericality: { only_integer: true, allow_blank: true }
  validates :kind, inclusion: { in: KINDS.keys }

  scope :companies, -> { where(kind: 0) }
  scope :departments, -> { where(kind: 100) }
  scope :folders, -> { where(kind: 200) }

  def self.kinds
    KINDS
  end

  def show_kind
    KINDS[kind]
  end

end
