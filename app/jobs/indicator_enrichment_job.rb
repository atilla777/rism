# frozen_string_literal: true

class IndicatorEnrichmentJob < ApplicationJob
  def perform(broker, indicator_id)
   @broker = broker
   @indicator = Indicator.find(indicator_id)
   enrichment_brocker = BaseBroker.broker_by_name(
     @broker
   ).constantize
   @result = enrichment_brocker.call(
     @indicator.content,
     @indicator.content_format
   )
   save_result
  end

  private

  def save_result
    @indicator.skip_current_user_check = true
    @indicator.enrichment[@broker] = @result
    @indicator.save!
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
          #{@indicator.errors.full_messages},
          indicator
          ID
          -
          #{@indicator.id}).join
      )
    end
  end
end
