# frozen_string_literal: true

module OrganizationMember
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_user

    # TODO: solve proble with - factory_bot to_create not work
    # (make session user  creation via User.new User.save(validation: false))
    # and remove unless below
    validate :organization_id_is_allowed, unless: -> { Rails.env.test? }

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

  def organization_id_is_allowed
    return if current_user.admin_editor?
    return if current_user.can?(:edit, self.class)
    return if current_user.allowed_organizations_ids.include?(organization_id)
    # TODO: add translation
    errors.add(:organization_id, 'parent id is not allowed')
  end
end
