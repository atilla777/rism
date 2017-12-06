class Attachment < ApplicationRecord
  include OrganizationMember

  mount_uploader :document, DocumentUploader

  accepts_nested_attributes_for :attachment_links

  validates :organization_id, numericality: { only_integer: true }

  belongs_to :organization

  has_many :attachment_links
  has_many :records, trough: :attachment_links
end
