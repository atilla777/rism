# frozen_string_literal: true

class ArticlesFolder < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  has_paper_trail

  # used in ui autocomplite in controller
  def show_full_name
    "#{name}, #{organization.name}"
  end

  validates :name, uniqueness: { scope: :organization_id }
  validates :name, length: { in: 1..250 }
  validates :parent_id, numericality: { only_integer: true, allow_blank: true }
  validates :rank, numericality: { only_integer: true, allow_blank: true }

  has_many :children,
           class_name: 'ArticlesFolder',
           foreign_key: :parent_id,
           dependent: :destroy

  belongs_to :parent, class_name: 'ArticlesFolder', optional: true

  has_many :articles, dependent: :destroy

  def top_level_articles_folders
    query = <<~SQL
      WITH RECURSIVE parents AS
      (
        SELECT *
        FROM articles_folders
        WHERE articles_folders.id = ?
        UNION
        SELECT articles_folders.*
        FROM parents, articles_folders
        WHERE parents.parent_id = articles_folders.id
      )
      SELECT * from parents
    SQL

    ArticlesFolder.find_by_sql([query, id])
  end
end
