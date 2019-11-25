# frozen_string_literal: true

class EnrichIndicatorService

  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(indicator, broker_name = nil)
    @indicator = indicator
    @useable_brokers = BaseBroker.useable_brokers(indicator.content_format)
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
    IndicatorEnrichmentJob.set(queue: broker.queue)
                          .perform_later(
                            broker.broker_name,
                            @indicator.id
                          )
  end

  def several_brokers
    @useable_brokers.each do |broker|
      IndicatorEnrichmentJob.set(queue: broker.queue)
                            .perform_later(
                              broker.broker_name,
                              @indicator.id
                            )
    end
  end
end
