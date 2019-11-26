# frozen_string_literal: true

module Enrichmentable
  extend ActiveSupport::Concern

  included do
    has_many :enrichments, as: :enrichmentable, dependent: :delete_all
  end

  # In class that include this module should exists attributes:
  # content_format
  # Also should be peresent method #original_class in model or model decorator

  def enrichment_danger_detect?
    enrichments.detect do |enrichment|
      enrichment.parser.danger?(enrichment.content)
    end
  end

  def show_kaspesky_hash_enrichment
    enrichments.each do |enrichment|
      parser = enrichment.parser
      verdict = parser.kaspesky_danger_verdict(enrichment.content)
      return verdict if verdict.present?
    end
    nil
  end
end
