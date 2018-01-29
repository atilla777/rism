# frozen_string_literal: true

class Department < ApplicationRecord
  include OrganizationMember

  validates :name, uniqueness: { scope: :organization_id }
  validates :name, length: { in: 1..100 }
  validates :organization_id, numericality: { only_integer: true }
  validates :parent_id, numericality: { only_integer: true, allow_blank: true }
  validates :rank, numericality: { only_integer: true, allow_blank: true }

  has_many :children,
           class_name: 'Department',
           foreign_key: :parent_id,
           dependent: :destroy

  belongs_to :parent, class_name: 'Department', optional: true

  has_many :rights, as: :subject, dependent: :destroy

  has_many :users, dependent: :destroy

  def top_level_departments
    query = <<~SQL
      WITH RECURSIVE parents AS
      (
        SELECT *
        FROM departments
        WHERE departments.id = ?
        UNION
        SELECT departments.*
        FROM parents, departments
        WHERE parents.parent_id = departments.id
      )
      SELECT * from parents
    SQL

    Department.find_by_sql([query, id])
  end
end
