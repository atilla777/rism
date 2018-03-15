class AttachmentPolicy < ApplicationPolicy
  def permitted_attributes
    [:name, :document, :organization_id,
     attachment_links_attributes: [:record_type, :record_id]]
  end

  def download?
    return true if @user.admin_editor_reader?
    @user.can? :read, @record
  end

end
