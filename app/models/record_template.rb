class RecordTemplate < ApplicationRecord
  include Linkable
  include Tagable
  include Attachable

  RECORD_TYPES = {
    'Organization' => I18n.t('activerecord.models.organization.one'),
    'User' => I18n.t('activerecord.models.user.one'),
    'Agreement' => I18n.t('activerecord.models.agreement.one'),
    'Incident' => I18n.t('activerecord.models.incident.one'),
    'Investigation' => I18n.t('activerecord.models.investigation.one'),
  }.freeze

  SHARING_OPTIONS = %i[all organization personal]

  def self.record_types
    RECORD_TYPES
  end

  def self.sharing_options
    SHARING_OPTIONS
  end

  def self.allowed_for_model(model, current_user)
    sql = <<~SQL
      record_type = ? AND (
        user_id = ? OR
        organization_id = ? OR
        (user_id IS NULL AND organization_id IS NULL)
      )
    SQL
    where(sql, model, current_user.id, current_user.organization_id)
  end

  include RecordTemplate::Ransackers

  serialize :record_content, JSON

  after_create :add_tags

  attr_accessor :current_user
  attr_accessor :record_tags
  attr_accessor :sharing_option

  validates :name, uniqueness: true
  validates :name, length: { in: 3..150 }
  validates :record_content, presence: true
  validates :record_type, inclusion: { in: record_types.keys }
  validates :user_id,
            numericality: { only_integer: true, allow_blank: true }
  validates :organization_id,
            numericality: { only_integer: true, allow_blank: true }

  belongs_to :user, optional: true
  belongs_to :organization, optional: true

  before_validation :set_sharing_option

  def add_tags
    return if record_tags.blank?
    self.record_tags.each do |tag_id|
      tag_members.create(tag_id: tag_id)
    end
  end

  def current_sharing_option
    return :organization if organization_id.present?
    return :personal if organization_id.present?
    :all
  end

  private

  def set_sharing_option
    if sharing_option == 'personal'
      self.user_id = current_user.id
    elsif sharing_option == 'organization'
      self.organization_id = current_user.organization_id
    end
  end
end
