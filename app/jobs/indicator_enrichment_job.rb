# frozen_string_literal: true

class IndicatorEnrichmentJob < ApplicationJob
  ENRICHMENT_BROCKERS = {
    virus_total: 'IndicatorEnrichment::VirusTotalBrocker'
  }.freeze

  queue_as do
    self.arguments&.first || :default
  end

  def perform(_, indicator_id, enrichment_service_name)
   @enrichment_service_name = enrichment_service_name
   @indicator = Indicator.find(indicator_id)
   enrichment_brocker = ENRICHMENT_BROCKERS[enrichment_service_name.to_sym].constantize
   @result = enrichment_brocker.call(
     @indicator.content,
     @indicator.content_format
   )
   save_result
  end

  private

  def save_result
    if @indicator.enrichment == '{}'
      @indicator.enrichment = {}
    end
    @indicator.skip_current_user_check = true
    @indicator.enrichment[@enrichment_service_name] = @result
    @indicator.save!
  rescue ActiveRecord::RecordInvalid
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
    logger.tagged("INDICATOR_ENRICHMENT: ") do
      logger.error(
        "indicator enrichment can`t be saved - #{@indicator.errors.full_messages}, indicator ID-  #{@indicator.id}"
      )
    end
  end
end
