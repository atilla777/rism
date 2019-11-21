# frozen_string_literal: true

class EnrichmentsController < ApplicationController
  def create
    record = Indicator.find(params[:id])
    authorize record
    enrich_indicator(record)
  end

  def index
    @indicator = Indicator.find(params[:indicator_id])
    authorize @indicator
    @decorated_indicator = IndicatorDecorator.new(@indicator)
  end

  def show
    @indicator = Indicator.find(params[:id])
    authorize @indicator
    @decorated_indicator = IndicatorDecorator.new(@indicator)
    format = Indicator::Enrichments.map_hash_format(@indicator.content_format)
    service_name = Indicator::Enrichments.enrichment_by_name(params[:service_name])
    @enrichment = @indicator.enrichment.fetch(service_name)
    render "indicator_enrichments/#{format}_#{service_name}", layout: false
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
