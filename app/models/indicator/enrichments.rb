# frozen_string_literal: true

module Indicator::Enrichments
  ENRICHMENTS = %w[
    virus_total
  ]

  module_function

  def enrichment_by_name(name)
    name if ENRICHMENTS.detect(name)
  end
end
