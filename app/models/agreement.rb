class Agreement < ApplicationRecord
  include OrganizationMember

  ransacker :beginning do
    Arel.sql("to_char(beginning, 'DD.MM.YYYY')")
  end

  validates :beginning, presence: true
  validates :prop, length: {minimum: 1, maximum: 100 }
  validates :organization_id, numericality: { only_integer: true }
  validates :contractor_id, numericality: { only_integer: true }

  belongs_to :organization
  belongs_to :contractor, class_name: 'Organization'

  has_many :attachment_links, as: :record

end
