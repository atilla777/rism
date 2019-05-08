# frozen_string_literal: true

class Incident < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Incident::Ransackers
  include PgSearch
  include Rightable

  multisearchable(
    against: [:name, :event_description, :investigation_description, :action_description]
  )

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

  has_paper_trail

  validates :name, length: { in: 3..100, allow_blank: true }
  validates :user_id, numericality: { only_integer: true }
  validates :event_description, presence: true
  validates :damage, inclusion: { in: DAMAGES.keys }
  validates :severity, inclusion: { in: SEVERITIES.keys }
  validates :state, inclusion: { in: STATES.keys }

  accepts_nested_attributes_for :links

  belongs_to :user

  has_many(
    :incident_organizations,
    as: :second_record,
    through: :links,
    source: :second_record,
    source_type: 'Organization'
  )

  # Filter to show in incident index only Incident specific tags
  has_many(
    :incident_tags,
    -> { joins(
      <<~SQL
        INNER JOIN tag_kinds
        ON tag_kinds.id = tags.tag_kind_id
        AND tag_kinds.record_type = 'Incident'
      SQL
    ) },
    through: :tag_members,
    source: :tag
  )

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

  def self.damage_to_color code
    COLORS[code]
  end

  def self.severity_to_color code
    COLORS[code + (code < 1 ? 0 : 1)]
  end

  def self.state_to_color code
    COLORS.reverse[code]
  end

  # for use with RecordTemplate, Link and etc
  def show_full_name
    IncidentDecorator.new(self).show_full_name
  end

  def damage_color
    Incident.damage_to_color damage
  end

  def severity_color
    Incident.severity_to_color severity
  end

  def state_color
    Incident.state_to_color state
  end

  private

  def set_closed_at
    return unless changed.include?('state')
    self.closed_at = (state == 2) ? Time.current : nil
  end
end
