class Investigation < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Investigation::Ransackers

#  enum threat: %i[
#                  other
#                  network
#                  email
#                  process
#                  account
#                 ]

  attr_accessor :indicators_list

  before_validation :set_name
#  after_create :set_indicators

  validates :name, length: { in: 3..100 }
  validates :feed_id, numericality: { only_integer: true }
  validates :organization_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
 # validates :threat, inclusion: { in: Investigation.threats.keys}

  belongs_to :user
  belongs_to :organization
  belongs_to :feed
  belongs_to :investigation_kind
  has_many :indicators, dependent: :destroy

  has_many :delivery_subjects, as: :deliverable, dependent: :delete_all
  has_many :delivery_lists, through: :delivery_subjects


  def allowed_delivery_lists
    DeliveryList.all - delivery_lists
  end

#  def self.assigned_delivery_subjects(record)
#    DeliverySubject.where(
#      deliverable_type: record.class.model_name.to_s,
#      deliverable_id: record.id
#    )
#  end

  private

  def set_name
    return if name.present?
    self.name = investigation_kind&.name
  end

#  def set_indicators
#    CreateIndicatorsService.call(indicators_list, id, user_id)
#  end
end
