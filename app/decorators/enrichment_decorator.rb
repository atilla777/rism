# frozen_string_literal: true

class EnrichmentDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_broker
    Enrichment.human_enum_name(:broker, broker)
  end
end
