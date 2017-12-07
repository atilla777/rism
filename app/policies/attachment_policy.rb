class AttachmentPolicy < ApplicationPolicy
  def permitted_attributes
    [:name, :document, :organization_id,
     attachment_link_attributes: [:id, :attachment_id, :record_type, :record_id]]
  end

end
