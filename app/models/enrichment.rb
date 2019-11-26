# frozen_string_literal: true

class Enrichment < ApplicationRecord
  ENRICHEMNTABLE_TYPES = %w[
    Indicator
  ].freeze

  self.record_timestamps = false

  def self.enrichmentable_types
    ENRICHEMNTABLE_TYPES
  end

  enum broker: %i[
    virus_total
    x_force
  ]

  validates :content, presence: true
  validates :enrichmentable_type, inclusion: { in: enrichmentable_types }

  belongs_to :enrichmentable, polymorphic: true

  def parser
    "#{broker}_parser".camelcase.constantize
  end
end
