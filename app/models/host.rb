# frozen_string_literal: true

class Host < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Host::Ransackers
  include Rightable
  include MassSave
  include Readable
  include Monitorable

  has_paper_trail

  attr_accessor :to_hosts

  validates :name, length: { in: 3..200, allow_blank: true }
  validates :name, uniqueness: { scope: :organization_id, allow_blank: true }
  validates :ip, uniqueness: true
  validates :ip, presence: true

  has_many :host_services, dependent: :destroy

  has_many :scan_jobs_hosts, dependent: :delete_all
  has_many :scan_jobs, through: :scan_jobs_hosts
  #
  # for use with RecordTemplate, Link and etc
  def show_full_name
    result = [ip]
    result << name if name.present?
    result.join(' ')
  end
end
