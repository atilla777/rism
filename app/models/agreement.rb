# frozen_string_literal: true

class Agreement < ApplicationRecord
  include OrganizationMember

  ransacker :beginning do
    Arel.sql("to_char(beginning, 'YYYY.MM.DD')")
  end

  validate :organization_not_contrcator
  validates :beginning, presence: true
  validates :prop, length: { minimum: 1, maximum: 100 }
  validates :beginning, uniqueness: { scope: [:prop, :organization_id] }
  validates :organization_id, numericality: { only_integer: true }
  validates :agreement_kind_id, numericality: { only_integer: true, allow_blank: true }
  validates :contractor_id, numericality: { only_integer: true }

  belongs_to :organization
  belongs_to :contractor, class_name: 'Organization'
  belongs_to :agreement_kind, optional: true

  has_many :tag_members, as: :record, dependent: :destroy
  has_many :tags, through: :tag_members

  # TODO move code to attachable concern
  has_many :attachment_links, as: :record, dependent: :destroy
  has_many :attachments, through: :attachment_links

  has_many :rights, as: :subject, dependent: :destroy

  private

  def organization_not_contrcator
    return unless organization_id == contractor_id
    errors.add(:organization_id, 'can`t be as contractor')
    errors.add(:contractor_id, 'can`t be as organization')
  end
end
