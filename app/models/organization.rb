# frozen_string_literal: true

class Organization < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Rightable
  include Recipientable

  attr_accessor :current_user

  has_paper_trail

  validates :name, uniqueness: true
  validates :codename, uniqueness: true
  validates :name, length: { in: 1..100 }
  validates :codename, length: { in: 1..15 }
  validates :full_name, uniqueness: true, allow_blank: true
  validates :full_name, length: { in: 1..200, allow_blank: true }
  validates :parent_id, numericality: { only_integer: true, allow_blank: true }
  validates :organization_kind_id, numericality: { only_integer: true, allow_blank: true }

  # Organization here is like a security domain (scope)
  has_many :right_scopes, class_name: 'Right', dependent: :delete_all

  # Organization here is like an access subject
  # See below code in Rightable concern
  # has_many :rights, as: :subject, dependent: :destroy

  has_many :users, dependent: :destroy

  has_many :departments, dependent: :destroy

  has_many :hosts, dependent: :destroy

  has_many :agreements, dependent: :destroy
  has_many :contracts,
           class_name: 'Agreement',
           foreign_key: :contractor_id,
           dependent: :destroy

  # organization is owner of some incidents (as access subject)
  has_many :incidents, dependent: :destroy

  has_many :scan_jobs, dependent: :destroy

  has_many :children,
           class_name: 'Organization',
           foreign_key: :parent_id,
           dependent: :destroy

  belongs_to :parent, class_name: 'Organization', optional: true

  belongs_to :organization_kind, optional: true

  has_many :delivery_lists, through: :delivery_recipients

  has_many :record_templates

  has_many :vulnerability_bulletin_statuses, dependent: :delete_all

  has_many :agents, dependent: :destroy

  before_destroy :protect_default_organization

  scope :default_organization, -> { find(1) }

  # Array of child organizations ids.
  # For example organization with id 1 has childs with ids 34, 45 and 57:
  # Organization.down_level_organizations(1)
  # wil give result [34, 45, 57]
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
                .pluck(:id)
  end

  def self.top_level_organizations(id_of_organization)
    query = <<~SQL
      WITH RECURSIVE parents(id, parent_id) AS
      (
        SELECT organizations.id, organizations.parent_id
        FROM organizations
        WHERE organizations.id = ?
        UNION
        SELECT organizations.id, organizations.parent_id
        FROM parents, organizations
        WHERE parents.parent_id = organizations.id
      )
      SELECT id from parents
    SQL

    Organization.find_by_sql([query, id_of_organization])
  end


  # for use with RecordTemplate, Link and etc
  def show_full_name
    name
  end

  private

  # Prevent builtin default organization
  # to be deleted
  def protect_default_organization
    return unless id == 1
    errors.add(:base, :organization_is_built_in)
    throw :abort
  end

  def organization_id_is_allowed
    return if current_user.admin_editor?
    return if current_user.can?(:edit, self.class)
    return if current_user.allowed_organizations_ids.include?(parent_id)
    # TODO: add translation
    errors.add(:parent_id, 'parent id is not allowed')
  end
end
