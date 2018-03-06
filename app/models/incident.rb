# frozen_string_literal: true
class Incident < ApplicationRecord
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

  ransacker :discovered_at do
    datetime_field_to_text_search 'discovered_at'
  end

  ransacker :started_at do
    datetime_field_to_text_search 'started_at'
  end

  ransacker :created_at do
    datetime_field_to_text_search 'created_at'
  end

  ransacker :finished_at do
    datetime_field_to_text_search 'finished_at'
  end

  ransacker :closed_at do
    datetime_field_to_text_search 'closed_at'
  end

  ransacker :severity do
    field_transformation = <<~SQL
      CASE severity
      WHEN 0
      THEN '#{SEVERITIES[0]}'
      WHEN 1
      THEN '#{SEVERITIES[1]}'
      END
    SQL
    Arel.sql(field_transformation)
  end

  ransacker :damage do
    field_transformation = <<~SQL
      CASE damage
      WHEN 0
      THEN '#{DAMAGES[0]}'
      WHEN 1
      THEN '#{DAMAGES[1]}'
      WHEN 2
      THEN '#{DAMAGES[2]}'
      END
    SQL
    Arel.sql(field_transformation)
  end

  ransacker :state do
    field_transformation = <<~SQL
      CASE state
      WHEN 0
      THEN '#{STATES[0]}'
      WHEN 1
      THEN '#{STATES[1]}'
      WHEN 2
      THEN '#{STATES[2]}'
      END
    SQL
    Arel.sql(field_transformation)
  end

  validates :event_description, presence: true
  validates :damage, inclusion: { in: DAMAGES.keys }
  validates :severity, inclusion: { in: SEVERITIES.keys }
  validates :state, inclusion: { in: STATES.keys }

  has_many :tag_members, as: :record, dependent: :destroy
  has_many :tags, through: :tag_members

  # TODO move code to attachable concern
  has_many :attachment_links, as: :record, dependent: :destroy
  has_many :attachments, through: :attachment_links

  private

  def self.datetime_field_to_text_search(fieled)
    field_transformation = <<~SQL
      to_char(
        ((#{fieled} AT TIME ZONE 'UTC') AT TIME ZONE '#{timezone_name}'),
        'YYYY.MM.DD-HH24:MI'
      )
    SQL
    Arel.sql field_transformation
  end

  def self.timezone_name
    ActiveSupport::TimeZone.find_tzinfo(Time.zone.name).identifier
  end

  def self.damages
    DAMAGES
  end

  def self.severities
    SEVERITIES
  end

  def self.states
    STATES
  end
end
