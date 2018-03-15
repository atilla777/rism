# frozen_string_literal: true

class Attachment < ApplicationRecord
  include OrganizationMember

  mount_uploader :document, DocumentUploader

  attr_accessor :skip_child_validation

  validates :name, length: { minimum: 1, maximum: 100, allow_blank: true }
  validates :organization_id, numericality: { only_integer: true }
  validates :document, presence: true

  belongs_to :organization

  has_many :attachment_links, dependent: :destroy


  has_many :agreements,
           through: :attachment_links,
           source: :record,
           source_type: 'Agreement'

  has_many :incidents,
           through: :attachment_links,
           source: :record,
           source_type: 'Incident'

  has_many :rights, as: :subject, dependent: :destroy


  accepts_nested_attributes_for :attachment_links#, reject_if: proc { |attributes| attributes[:document].blank? }
end
