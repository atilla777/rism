class Attachment < ApplicationRecord
  include OrganizationMember

  mount_uploader :document, DocumentUploader

  validates :organization_id, numericality: { only_integer: true }

  belongs_to :organization
end
