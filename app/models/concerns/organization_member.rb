module OrganizationMember
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_user
    validate :organization_id_allowed?
  end


  def top_level_organizations
    id_of_organization =  if model_name == 'Organization'
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

  private
  def organization_id_allowed?
    unless current_user.admin_editor?
      unless current_user.allowed_organizations_ids.include?(organization_id) && organization_id.present?
        errors.add(:organization_id, 'Not allowed organization')
      end
    end
  end
end
