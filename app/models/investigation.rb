# frozen_string_literal: true

class Investigation < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Investigation::Ransackers
  include CustomFieldable
  include Monitorable
  include Deliverable
  include Readable

  attr_accessor :indicators_list, :enrich

  before_validation :set_name
  before_validation :set_custom_codename

  validates :name, length: { in: 3..200 }
  validates :custom_codename, length: { in: 3..200, allow_blank: true }
  validates :custom_codename, uniqueness: true, allow_blank: true
  validates :feed_codename, length: { in: 3..200, allow_blank: true }
  validates :feed_id, numericality: { only_integer: true }
  #validates :organization_id, numericality: { only_integer: true }

  belongs_to :organization
  belongs_to :feed
  belongs_to :investigation_kind
  has_many :indicators, dependent: :destroy

#  has_many :delivery_subjects, as: :deliverable, dependent: :delete_all
#  has_many :delivery_lists, through: :delivery_subjects

  def top_parents_indicators
    indicators.where(parent_id: nil)
  end


  def allowed_delivery_lists
    DeliveryList.all - delivery_lists
  end

  private

  def set_name
    return if name.present?
    self.name = investigation_kind&.name
  end

  def set_custom_codename
    return if custom_codename.present?
    self.custom_codename = Custom::InvestigationCustomization.cast_custom_codename(self)
  end
end
