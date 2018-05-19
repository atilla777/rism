class ScanResult < ApplicationRecord
  include OrganizationMember

  belongs_to :organization
  belongs_to :scan_job

  enum state: [ :closed, :open, :filtered_open, :filtered_closed]
  enum legality: [:illegal, :unknown, :legal]
end
