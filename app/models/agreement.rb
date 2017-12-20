class Agreement < ApplicationRecord
  include OrganizationMember

  ransacker :beginning do
    Arel.sql("to_char(beginning, 'DD.MM.YYYY')")
  end

  validate :organization_not_contrcator
  validates :beginning, presence: true
  validates :prop, length: {minimum: 1, maximum: 100 }
  validates :beginning, uniqueness: { scope: [:prop, :organization_id] }
  validates :organization_id, numericality: { only_integer: true }
  validates :agreement_kind_id, numericality: { only_integer: true }
  validates :contractor_id, numericality: { only_integer: true }

  belongs_to :organization
  belongs_to :contractor, class_name: 'Organization'
  belongs_to :agreement_kind

  has_many :attachment_links, as: :record
  has_many :attachments, through: :attachment_links

  private
  def organization_not_contrcator
    if organization_id == contractor_id
      errors.add(:organization_id, 'can`t be as contractor')
      errors.add(:contractor_id, 'can`t be as organization')
    end
  end
end
