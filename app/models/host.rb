class Host < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Host::Ransackers

  has_paper_trail

  validates :name, length: { in: 3..200 }
  validates :name, uniqueness: { scope: :organization_id }
  validates :ip, uniqueness: { scope: :organization_id }
  validates :ip, presence: true
  validates :organization_id, numericality: { only_integer: true }

  belongs_to :organization
  #
  # for use with RecordTemplate, Link and etc
  def show_full_name
    "#{name} (#{ip})"
  end
end
