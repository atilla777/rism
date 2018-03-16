# frozen_string_literal: true

class Incident < ApplicationRecord
  include Linkable
  include Incident::Ransackers

  COLORS = ['#228B22', '#DAA520', '#DC143C'].freeze

  DAMAGES = {
    0 => I18n.t('incidents.damages.not_present'),
    1 => I18n.t('incidents.damages.unknown'),
    2 => I18n.t('incidents.damages.present')
  }.freeze

  SEVERITIES = {
    0 => I18n.t('incidents.severities.low'),
    1 => I18n.t('incidents.severities.hi')
  }.freeze

  STATES = {
    0 => I18n.t('incidents.states.registered'),
    1 => I18n.t('incidents.states.processed'),
    2 => I18n.t('incidents.states.closed')
  }.freeze

  def self.damages
    DAMAGES
  end

  def self.severities
    SEVERITIES
  end

  def self.states
    STATES
  end

  validates :name, length: { in: 3..100, allow_blank: true }
  validates :event_description, presence: true
  validates :damage, inclusion: { in: DAMAGES.keys }
  validates :severity, inclusion: { in: SEVERITIES.keys }
  validates :state, inclusion: { in: STATES.keys }

  # TODO: move code to taggable concern
  has_many :tag_members, as: :record, dependent: :destroy
  has_many :tags, through: :tag_members

  # TODO: move code to linkable concern
#  has_many :links, as: :first_record, dependent: :destroy
#  has_many :second_records, through: :links
#
#  has_many :organizations, through: :links

  accepts_nested_attributes_for :links

  # TODO: move code to attachable concern
  has_many :attachment_links, as: :record, dependent: :destroy
  has_many :attachments, through: :attachment_links

  before_save :set_closed_at

  # for use with RecordTemplate, Link and etc
  def show_full_name
    name
  end

  def damage_color
    COLORS[damage]
  end

  def severity_color
    COLORS[severity + (severity < 1 ? 0 : 1)]
  end

  def state_color
    COLORS.reverse[state]
  end

  private

  def set_closed_at
    return unless changed.include?('state')
    self.closed_at = (state == 2) ? Time.current : nil
  end
end
