# frozen_string_literai: true

class EnrichmentJob < ApplicationJob
  queue_as do
    self.arguments.first.to_sym
  end

  def perform(_queue, broker, enrichmentable_type, enrichmentable_id)
   model = enrichmentable_type.constantize
   @enrichmentable = model.find(enrichmentable_id)
   @broker = BaseBroker.broker_by_name(
     broker
   ).constantize
   @result = @broker.call(
     @enrichmentable.content,
     @enrichmentable.content_format
   )
   save_result
  end

  private

  def save_result
    @enrichment = Enrichment.new(
      content: @result,
      broker: @broker.broker_name,
      enrichmentable: @enrichmentable,
      created_at: DateTime.now
    )
    @enrichment.save!
  rescue ActiveRecord::RecordInvalid
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
    logger.tagged("ENRICHMENT (#{Time.now}): ") do
      logger.error(
        %W(
          enrichmentable
          enrichment
          can`t
          be
          saved
          -
          #{@enrichment.errors.full_messages},
          enrichmentable
          ID
          -
          #{@enrichmentable.id}).join(' ')
      )
    end
  end
end
