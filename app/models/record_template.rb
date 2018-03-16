class RecordTemplate < ApplicationRecord
  include Linkable

  RECORD_TYPES = {
    'Organization' => I18n.t('activerecord.models.organization.one'),
    'User' => I18n.t('activerecord.models.user.one'),
    'Agreement' => I18n.t('activerecord.models.agreement.one'),
    'Incident' => I18n.t('activerecord.models.incident.one'),
  }.freeze

  def self.record_types
    RECORD_TYPES
  end

  def self.allowed_for_model(model)
    where(record_type: model)
  end

  include RecordTemplate::Ransackers

  serialize :record_content, JSON
  serialize :record_tags, Array

  validates :name, uniqueness: true
  validates :name, length: { in: 3..150 }
  validates :record_content, presence: true
  validates :record_type, inclusion: { in: record_types.keys }

  after_save :add_tags

  # TODO: move code to taggable concern
  has_many :tag_members, as: :record, dependent: :destroy
  has_many :tags, through: :tag_members

  # TODO: move code to attachable concern
  has_many :attachment_links, as: :record, dependent: :destroy
  has_many :attachments, through: :attachment_links

  attr_accessor :record_tags#, :record_links, :record_attachment_links

  def add_tags
    self.record_tags.each do |tag_id|
      tag_members.create(tag_id: tag_id)
    end
  end
end
