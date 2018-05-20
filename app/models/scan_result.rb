# frozen_string_literal: true

class ScanResult < ApplicationRecord
  COLORS = ['#228B22', '#DAA520', '#DC143C'].freeze

  include OrganizationMember

  enum state: %i[closed closed_filtered filtered unfiltered open_filtered open]
  enum legality: %i[illegal unknown legal]

  validates :organization_id, numericality: { only_integer: true }
  validates :scan_job_id, numericality: { only_integer: true }
  validates :start, presence: true
  validates :finished, presence: true
  validates :ip, presence: true
  validates :port, presence: true
  validates :protocol, presence: true
  validates :legality, inclusion: { in: ScanResult.legalities.keys }
  validates :state, inclusion: { in: ScanResult.states.keys }

  belongs_to :organization
  belongs_to :scan_job

  def state_color
    ScanResult.state_to_color state
  end

  def self.state_to_color code
    if code == 0 || code == 2
      COLORS.reverse[code]
    else
      COLORS.reverse[1]
    end
  end

  def legality_color
    ScanResult.legality_color legality
  end

  def self.legality_to_color code
    COLORS.reverse[code]
  end
end
