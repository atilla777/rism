# frozen_string_literal: true

module Enrichmentable
  extend ActiveSupport::Concern

  included do
    has_many :enrichments, as: :enrichmentable, dependent: :delete_all
  end

  # In class that include this module should exists attributes:
  # content_format
  # Also should be peresent method #original_class in model or model decorator

  def danger_in_enrichments?
    return :none if enrichments.blank?
    result = enrichments.detect do |enrichment|
      enrichment.parser.call(:danger?, enrichment.content)
    end
    result ? :yes : :no
  end

  def danger_verdict
    enrichments.each do |enrichment|
      parser = enrichment.parser
      verdict = parser.call(:danger_verdict, enrichment.content)
      return verdict if verdict.present?
    end
    nil
  end
end
