class RecordTemplate < ApplicationRecord
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
  serialize :record_tags, JSON

  validates :name, uniqueness: true
  validates :name, length: { in: 3..150 }
  validates :record_content, presence: true
  validates :record_type, inclusion: { in: record_types.keys }

 # before_save :set_content_and_tags

#  private
#
#  def set_content_and_tags
#    self.record_content = JSON.parse(self.record_content)
#    self.record_tags = JSON.parse(self.record_tags)
#  end
end
