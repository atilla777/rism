# frozen_string_literal: true

class HostService < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include HostService::Ransackers

  PROTOCOLS = %w[tcp udp]

  has_paper_trail

  enum legality: %i[illegal unknown legal no_sense]

  validates :organization_id, numericality: { only_integer: true }
  validates :host_id, numericality: { only_integer: true }
  validates :name, length: { in: 3..200, allow_blank: true }
  validates :port,
            uniqueness: { scope: [:protocol, :host_id] },
            allow_blank: true
  validates :port, inclusion: { in: 0..65535 }
  validates :protocol, presence: true
  validates :legality, inclusion: { in: ScanResult.legalities.keys}

  belongs_to :organization
  belongs_to :host

  def self.protocols
    PROTOCOLS
  end

  def show_full_name
    "#{name} #{port} #{protocol}"
  end

  def legality_color
    ScanResult.legality_to_color ScanResult.legalities[legality]
  end
end
