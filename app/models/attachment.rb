# frozen_string_literal: true

class Attachment < ApplicationRecord
  include OrganizationMember
  include Rightable

  mount_uploader :document, DocumentUploader

  validates :name, length: { minimum: 1, maximum: 100, allow_blank: true }
  validates :document, presence: true

  has_many :attachment_links, dependent: :destroy

  has_many :agreements,
           through: :attachment_links,
           source: :record,
           source_type: 'Agreement'

  has_many :incidents,
           through: :attachment_links,
           source: :record,
           source_type: 'Incident'

  accepts_nested_attributes_for :attachment_links
end
