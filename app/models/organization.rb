# frozen_string_literal: true

class Organization < ApplicationRecord
  include OrganizationMember
  include Linkable

  searchable_for_link_by :name

  has_paper_trail

  validates :name, uniqueness: true
  validates :name, length: { in: 1..100 }
  validates :full_name, uniqueness: true, allow_blank: true
  validates :full_name, length: { in: 1..200, allow_blank: true }
  validates :parent_id, numericality: { only_integer: true, allow_blank: true }
  validates :organization_kind_id, numericality: { only_integer: true, allow_blank: true }

  # Organization here is like a security domain (scope)
  has_many :right_scopes, class_name: 'Right', dependent: :destroy

  # Organization here is like an access subject
  has_many :rights, as: :subject, dependent: :destroy

  has_many :users, dependent: :destroy

  has_many :departments, dependent: :destroy

  has_many :agreements, dependent: :destroy
  has_many :contracts,
           class_name: 'Agreement',
           foreign_key: :contractor_id,
           dependent: :destroy

  has_many :children,
           class_name: 'Organization',
           foreign_key: :parent_id,
           dependent: :destroy
  belongs_to :parent, class_name: 'Organization', optional: true

  belongs_to :organization_kind, optional: true

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
end
