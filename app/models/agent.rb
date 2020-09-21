class Agent < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  validates :name, length: {minimum: 3, maximum: 250}
  validates :name, uniqueness: {scope: :organization_id}
  validates :address, presence: true, unless: :hostname
  validates :hostname, presence: true, unless: :address
  validates :port, uniqueness: true
  validates :secret, presence: true

  has_many :scan_jobs
end
