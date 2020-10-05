class Agent < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  PROTOCOLS = {
    http: 'http',
    https: 'https'
  }.freeze

  enum protocol: PROTOCOLS, _prefix: true

  validates :name, length: {minimum: 3, maximum: 250}
  validates :name, uniqueness: {scope: :organization_id}
  validates :hostname, presence: true, unless: :address
  validates :address, presence: true, unless: :hostname
  validates :protocol, inclusion: {in: Agent.protocols.values}
  validates :port, presence: true
  validates :secret, presence: true

  has_many :scan_jobs
  has_many :scan_job_logs
end
