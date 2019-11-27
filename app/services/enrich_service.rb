# frozen_string_literal: true

class EnrichService

  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(enrichmentable, broker_name = nil)
    @enrichmentable = enrichmentable
    @broker_name = broker_name
  end

  def execute
    if @broker_name
      one_broker
    else
      several_brokers
    end
  end

  private

  def one_broker
    broker = BaseBroker.broker_by_name(@broker_name).constantize
    EnrichmentJob.perform_later(
      broker.queue,
      broker.broker_name,
      @enrichmentable.class.name,
      @enrichmentable.id
    )
  end

  def several_brokers
    useable_brokers = BaseBroker.useable_brokers(@enrichmentable.content_format)
    useable_brokers.each do |broker|
      EnrichmentJob.perform_later(
        broker.queue,
        broker.broker_name,
        @enrichmentable.class.name,
        @enrichmentable.id
      )
    end
  end
end
