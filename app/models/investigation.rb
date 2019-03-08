class Investigation < ApplicationRecord
  include OrganizationMember

  enum threat: %i[
                  other
                  network
                  email
                  process
                  account
                 ]

  validates :name, length: { in: 3..100 }
  validates :feed_id, numericality: { only_integer: true }
  validates :organization_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :threat, inclusion: { in: Investigation.threats.keys}

  belongs_to :user
  belongs_to :organization
  belongs_to :feed
end
