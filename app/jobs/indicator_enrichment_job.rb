# frozen_string_literai: true

class IndicatorEnrichmentJob < ApplicationJob
  def perform(broker, indicator_id)
   @indicator = Indicator.find(indicator_id)
   @broker = BaseBroker.broker_by_name(
     broker
   ).constantize
   @result = @broker.call(
     @indicator.content,
     @indicator.content_format
   )
   save_result
  end

  private

  def save_result
    @enrichment = Enrichment.new(
      content: @result,
      broker: @broker.broker_name,
      enrichmentable: @indicator,
      created_at: DateTime.now
    )
    @enrichment.save!
  rescue ActiveRecord::RecordInvalid
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
    logger.tagged("INDICATOR_ENRICHMENT (#{Time.now}): ") do
      logger.error(
        %W(
          indicator
          enrichment
          can`t
          be
          saved
          -
          #{@enrichment.errors.full_messages},
          indicator
          ID
          -
          #{@indicator.id}).join(' ')
      )
    end
  end
end
