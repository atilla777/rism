# frozen_string_literal: true

class Incident < ApplicationRecord
  include Incident::Ransackers

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

  validates :name, length: { in: 3..100, allow_blank: true }
  validates :event_description, presence: true
  validates :damage, inclusion: { in: DAMAGES.keys }
  validates :severity, inclusion: { in: SEVERITIES.keys }
  validates :state, inclusion: { in: STATES.keys }

  has_many :tag_members, as: :record, dependent: :destroy
  has_many :tags, through: :tag_members

  has_many :links, as: :first_record, dependent: :destroy
  has_many :second_records, through: :links

  # TODO: move code to attachable concern
  has_many :attachment_links, as: :record, dependent: :destroy
  has_many :attachments, through: :attachment_links

  before_save :set_closed_at

  def self.damages
    DAMAGES
  end

  def self.severities
    SEVERITIES
  end

  def self.states
    STATES
  end

  private

  def set_closed_at
    return unless changed.include?('state')
    self.closed_at = (state == 2) ? Time.current : nil
  end
end
