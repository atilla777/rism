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

  def show_link_to_service
    case broker
    when 'shodan'
      "https://www.shodan.io/host/#{enrichmentable.content}"
    when 'virus_total'
      "https://www.virustotal.com/gui/ip-address/#{enrichmentable.content}/detection"
    end
  end

end
