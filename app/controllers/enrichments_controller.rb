# frozen_string_literal: true

class EnrichmentsController < ApplicationController
  def index
    @indicator = Indicator.find(params[:indicator_id])
    authorize @indicator
    @decorated_indicator = IndicatorDecorator.new(@indicator)
    @usabale_brokers = BaseBroker.usabale_brokers(@indicator.content_format)
  end

  def show
    @indicator = Indicator.find(params[:id])
    authorize @indicator
    @decorated_indicator = IndicatorDecorator.new(@indicator)
    format = Indicator::Enrichments.map_hash_format(@indicator.content_format)
    broker = Indicator::Enrichments.enrichment_by_name(params[:broker_name])
    @enrichment = @indicator.enrichment.fetch(broker)
    render "enrichments/#{broker}/#{format}_#{broker}", layout: false
  end

  def create
    @indicator = Indicator.find(params[:indicator_id])
    authorize @indicator
    if params[:broker_name]
      EnrichIndicatorService.call(@indicator, params[:broker_name])
    else
      EnrichIndicatorService.call(@indicator)
    end
    @decorated_indicator = IndicatorDecorator.new(@indicator)
    render 'index'
  end

  private

  def enrich_indicator(indicator)
    unless Indicator::Enrichments.format_supported?(indicator.content_format, 'virus_total')
      return
    end
    IndicatorEnrichmentJob.perform_later(
      'free_virus_total_search',
      indicator.id,
      'virus_total'
    )
  end
end
