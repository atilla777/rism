class Investigation < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Investigation::Ransackers

  enum threat: %i[
                  other
                  network
                  email
                  process
                  account
                 ]

  attr_accessor :indicators_list

  before_validation :set_name
#  after_create :set_indicators

  validates :name, length: { in: 3..100 }
  validates :feed_id, numericality: { only_integer: true }
  validates :organization_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :threat, inclusion: { in: Investigation.threats.keys}

  belongs_to :user
  belongs_to :organization
  belongs_to :feed
  has_many :indicators, dependent: :destroy

  private

  def set_name
    return if name.present?
    self.name = InvestigationDecorator.new(self).show_threat
  end

#  def set_indicators
#    CreateIndicatorsService.call(indicators_list, id, user_id)
#  end
end
