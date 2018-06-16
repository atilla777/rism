# frozen_string_literal: true

module OrganizationRelative
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_user

    # TODO: solve problem with - factory_bot to_create not work
    # (make session user  creation via User.new User.save(validation: false))
    # and remove unless below
    validate :organization_id_is_allowed, unless: -> { Rails.env.test? }
  end

  def organization_id_is_allowed
    return if current_user.admin_editor?
    return if current_user.can_read_model_index?(self.class)
    return if current_user.allowed_organizations_ids.include?(organization_id)
    # TODO: add translation
    errors.add(:organization_id, 'parent id is not allowed')
  end
end
