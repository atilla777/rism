module User::HasRole
  extend ActiveSupport::Concern
  included do
    before_destroy :protect_admin

    has_many :role_members, dependent: :destroy
    has_many :roles, through: :role_members

  end

  def protect_admin
    if id == 1
      throw :abort
    end
  end

  def admin?
    roles.any?{ | role | role.id == 1 }
  end

  def admin_editor?
    roles.any?{ | role | (1..2).include? role.id }
  end

  def admin_editor_reader?
    roles.any?{ | role | (1..3).include? role.id }
  end

  # to do: make it through SQL
  def allowed_organizations_ids
    roles_ids = roles.pluck(:id)
    explicit_organizations_ids = Right.where(role_id: roles_ids)
                                      .pluck(:organization_id)
                                      .uniq
    implicit_organization_ids = []
    implicit_organization_ids += explicit_organizations_ids
    explicit_organizations_ids.each do | id_of_organization |
      implicit_organization_ids += Organization.down_level_organizations(id_of_organization).pluck(:id)
    end
    implicit_organization_ids.uniq
  end

  def can?(action, record_or_model)
    level = Right.action_to_level(action)
    case record_or_model
    when ActiveRecord::Base
      return can_access_record?(level, record_or_model.class.model_name.to_s, record_or_model)
    else Class
      return can_access_model?(level, record_or_model)
    end
  end

  private
  def can_access_model?(level, model)
    Right.where(role_id: roles)
         .where(subject_type: subject_type(model))
         .where('subject_id IS NULL')
         .where('rights.level <= ?', level)
         .present?
  end

  def can_access_record?(level, model, record)
    Right.where(role_id: roles)
         .where(organization_id: record.top_level_organizations)
         .where(subject_type: model)
         .where('subject_id = :record_id OR subject_id IS NULL', record_id: record.id)
         .where('rights.level <= ?', level)
         .present?

  end

  def subject_type(record_or_model)
    case record_or_model
    when ActiveRecord::Base
      record_or_model.class.model_name.to_s
    else Class
      record_or_model.to_s
    end
  end
end
