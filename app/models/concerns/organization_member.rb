# frozen_string_literal: true

module OrganizationMember
  extend ActiveSupport::Concern

  included do
    belongs_to :organization, optional: true
  end

  def top_level_organizations
    id_of_organization = if model_name == 'Organization'
                           id
                         else
                           organization_id
                         end

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
end
