class Investigation < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable

  enum threat: %i[
                  other
                  network
                  email
                  process
                  account
                 ]
  before_validation :set_name

  validates :name, length: { in: 3..100 }
  validates :feed_id, numericality: { only_integer: true }
  validates :organization_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :threat, inclusion: { in: Investigation.threats.keys}

  belongs_to :user
  belongs_to :organization
  belongs_to :feed

  private

  def set_name
    return if name.present?
    self.name = InvestigationDecorator.new(self).show_threat
  end
end
