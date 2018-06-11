# frozen_string_literal: true

class ScanResult < ApplicationRecord
  include OrganizationMember
  include ScanResult::Ransackers
  include Legalitiable

  enum state: %i[closed closed_filtered filtered unfiltered open_filtered open]

  validates :organization_id, numericality: { only_integer: true }
  validates :scan_job_id, numericality: { only_integer: true }
  validates :start, presence: true
  validates :finished, presence: true
  validates :ip, presence: true
  validates :port, inclusion: { in: 0..65535 }
  # TODO: use or delete
  #validates :protocol, presence: true
  validates :state, inclusion: { in: ScanResult.states.keys}

  belongs_to :organization
  belongs_to :scan_job
  belongs_to :host_service, foreign_key: :ip#, optional: true

  def state_color
    self.class.state_to_color self.class.states[state]
  end

  def self.state_to_color code
    if code == 0 || code == 2
      COLORS.reverse[code]
    else
      COLORS.reverse[1]
    end
  end
end
