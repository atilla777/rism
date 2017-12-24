class Attachment < ApplicationRecord
  include OrganizationMember

  mount_uploader :document, DocumentUploader

  validates :name, length: { minimum: 1, maximum: 100, allow_blank: true }
  validates :organization_id, numericality: { only_integer: true }

  belongs_to :organization

  has_many :attachment_links
  accepts_nested_attributes_for :attachment_links#, reject_if: proc { |attributes| attributes[:document].blank? }
  has_many :agreements, through: :attachment_links, source: :record, source_type: Agreement

  has_many :rights, as: :subject
end
