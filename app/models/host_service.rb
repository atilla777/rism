# frozen_string_literal: true

class HostService < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Legalitiable
  include HostService::Ransackers

  PROTOCOLS = %w[tcp udp]

  has_paper_trail

  validates :organization_id, numericality: { only_integer: true }
  validates :host_id, numericality: { only_integer: true }
  validates :name, length: { in: 3..200, allow_blank: true }
  validates :port,
            uniqueness: { scope: [:protocol, :host_id] },
            allow_blank: true
  validates :port, inclusion: { in: 0..65535 }
  validates :protocol, presence: true

  belongs_to :organization
  belongs_to :host

  def self.protocols
    PROTOCOLS
  end

  # TODO: add filter for allowed for job organizations
  def self.legality(ip, port, protocol, state)
    host_service = self.where(
      port: port, protocol: protocol
    )
    .joins(:host)
    .where(hosts: {ip: ip})
    .first
    if state.to_sym == :open
      return :unknown if host_service.blank?
      host_service.legality
    else
      :no_sense
    end
  end

  def show_full_name
    "#{name} #{port} #{protocol}"
  end
end
