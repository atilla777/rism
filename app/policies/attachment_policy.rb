# frozen_string_literal: true

class AttachmentPolicy < ApplicationPolicy
  def permitted_attributes
    %i[
      name
      document
      organization_id
    ] << {
      attachment_links_attributes: %i[
        record_type
        record_id
        nested
      ]
    }
  end

  def download?
    return true if @user.admin_editor_reader?
    @user.can? :read, @record
  end
end
