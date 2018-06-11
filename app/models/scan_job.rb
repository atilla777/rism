class ScanJob < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable

  has_paper_trail

  validates :name, length: { minimum: 3, maximum: 100 }
  validates :name, uniqueness: { scope: :organization_id }
  validates :organization_id, numericality: { only_integer: true }
  validates :scan_option_id, numericality: { only_integer: true }
  validates :hosts, presence: true

  belongs_to :organization
  belongs_to :scan_option

  has_one :schedule, as: :job, dependent: :destroy

  def worker
    'NetScanJob'
  end
end
