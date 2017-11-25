class Organization < ApplicationRecord
  include OrganizationMember

  KINDS = { 0 => I18n.t('organization_kinds.organization'),
            100 => I18n.t('organization_kinds.department'),
            200 => I18n.t('organization_kinds.folder') }.freeze

  has_many :right_scopes, class_name: 'Right', dependent: :destroy

  has_many :users, dependent: :destroy
  has_many :departments, dependent: :destroy
  has_many :agreements, dependent: :destroy
  has_many :contracts, class_name: 'Agreement', foreign_key: :contractor_id, dependent: :destroy

  has_many :rights, as: :subject, dependent: :destroy

  has_many :children, class_name: 'Organization', foreign_key: :parent_id, dependent: :destroy
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

  def self.down_level_organizations(id_of_organization)
    query = <<~SQL
      WITH RECURSIVE children(id, parent_id) AS
      (
        SELECT organizations.id, organizations.parent_id
        FROM organizations
        WHERE organizations.parent_id = ?
        UNION
        SELECT organizations.id, organizations.parent_id
        FROM children, organizations
        WHERE organizations.parent_id = children.id
      )
      SELECT id from children
    SQL

    Organization.find_by_sql([query, id_of_organization])
  end

  def show_kind
    KINDS[kind]
  end
end
