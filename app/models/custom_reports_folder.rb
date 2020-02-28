class CustomReportsFolder < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  has_paper_trail

  validates :name, uniqueness: { scope: :organization_id }
  validates :name, length: { in: 1..250 }
  validates :parent_id, numericality: { only_integer: true, allow_blank: true }
  validates :rank, numericality: { only_integer: true, allow_blank: true }

  has_many :children,
           class_name: 'CustomReportsFolder',
           foreign_key: :parent_id,
           dependent: :destroy

  belongs_to :parent, class_name: 'CustomReportsFolder', optional: true

  has_many :custom_reports, dependent: :destroy

  def top_level_folders
    query = <<~SQL
      WITH RECURSIVE parents AS
      (
        SELECT *
        FROM custom_reports_folders
        WHERE custom_reports_folders.id = ?
        UNION
        SELECT custom_reports_folders.*
        FROM parents, custom_reports_folders
        WHERE parents.parent_id = custom_reports_folders.id
      )
      SELECT * from parents
    SQL

    ArticlesFolder.find_by_sql([query, id])
  end
end
