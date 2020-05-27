# frozen_string_literal: true

class Enrichment < ApplicationRecord
  ENRICHEMNTABLE_TYPES = %w[
    Indicator
  ].freeze

  INFO_BROKERS = %w[shodan]

  self.record_timestamps = false

  def self.enrichmentable_types
    ENRICHEMNTABLE_TYPES
  end

  enum broker: %i[
    virus_total
    x_force
    shodan
  ]

  validates :content, presence: true
  validates :enrichmentable_type, inclusion: { in: enrichmentable_types }
  validates :enrichmentable_id, numericality: { only_integer: true }

  belongs_to :enrichmentable, polymorphic: true

  def parser
    "#{broker}_parser".camelcase.constantize
  end

  def danger?
    parser.call(:danger?, content)
  end

  def info?
    return true if INFO_BROKERS.include?(broker)
    false
  end

  def danger_verdict
    parser.call(:danger_verdict, content)
  end
end
