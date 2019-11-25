# frozen_string_literal: true

class EnrichmentsController < ApplicationController
  def index
    @enrichmentable = params[:enrichmentable_type].constantize
      .find(params[:enrichmentable_id])
    authorize @enrichmentable
#   decorator = "#{params[:enrichmentable_type]Decorator}".constantize
#   @decorated_enrichmentable = decorator.new(@enrichmentable)
    @useable_brokers = BaseBroker.useable_brokers(@enrichmentable.content_format)
    @enrichments = EnrichmentDecorator.wrap(
      @enrichmentable.enrichments.order(created_at: :desc)
    )
  end

  def show
    @enrichment = Enrichment.find(params[:id])
    @enrichmentable = @enrichment.enrichmentable
    authorize @enrichmentable
#   decorator = "#{params[:enrichmentable_type]Decorator}".constantize
#   @decorated_enrichmentable = decorator.new(@enrichmentable)
    format = Indicator::Enrichments.map_hash_format(@enrichmentable.content_format)
    render(
      "enrichments/#{@enrichment.broker}/#{format}_#{@enrichment.broker}",
      layout: false
    )
  end

  def create
    model = params[:enrichmentable_type].constantize
    @enrichmentable = model.find(params[:enrichmentable_id])
    authorize @enrichmentable
    if params[:broker_name]
      EnrichIndicatorService.call(@enrichmentable, params[:broker_name])
    else
      EnrichIndicatorService.call(@enrichmentable)
    end
#   decorator = "#{params[:enrichmentable_type]Decorator}".constantize
#   @decorated_enrichmentable = decorator.new(@enrichmentable)
    @useable_brokers = BaseBroker.useable_brokers(@enrichmentable.content_format)
    @enrichments = EnrichmentDecorator.wrap(
      @enrichmentable.enrichments.order(created_at: :desc)
    )
    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: 'ok' }
    end
  end

  def destroy
    @enrichment = Enrichment.find(params[:id])
    @enrichmentable = @enrichment.enrichmentable
    authorize @enrichmentable
    @enrichment.destroy
#   decorator = "#{params[:enrichmentable_type]Decorator}".constantize
#   @decorated_enrichmentable = decorator.new(@enrichmentable)
    @useable_brokers = BaseBroker.useable_brokers(@enrichmentable.content_format)
    @enrichments = EnrichmentDecorator.wrap(
      @enrichmentable.enrichments.order(created_at: :desc)
    )
    render 'index'
  end

#  private
#
#  def enrich_indicator(indicator)
#    unless Indicator::Enrichments.format_supported?(indicator.content_format, 'virus_total')
#      return
#    end
#    IndicatorEnrichmentJob.perform_later(
#      'free_virus_total_search',
#      indicator.id,
#      'virus_total'
#    )
#  end
end
