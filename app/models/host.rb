class Host < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable

  has_paper_trail

  validates :name, length: { in: 3..200 }
  validates :name, uniqueness: { scope: :organization_id }
  validates :ip, uniqueness: { scope: :organization_id }
  validates :ip, presence: true
  validates :organization_id, numericality: { only_integer: true }

  belongs_to :organization
end
