# frozen_string_literal: true

class EnrichmentsController < ApplicationController
  def index
    @enrichmentable = params[:enrichmentable_type].constantize
      .find(params[:enrichmentable_id])
    authorize @enrichmentable
    @enrichments = EnrichmentDecorator.wrap(
      # TODO: exclude where not when fix x_force via proxe auth
      @enrichmentable.enrichments
        .where.not(broker: :x_force)
        .order(created_at: :desc)
    )
    set_useable_btokers
  end

  def show
    @enrichment = Enrichment.find(params[:id])
    @enrichmentable = @enrichment.enrichmentable
    authorize @enrichmentable
    authorize Enrichment
    format = Indicator::Enrichments.map_hash_format(@enrichmentable.content_format)
    render(
      "enrichments/#{@enrichment.broker}/#{format}_#{@enrichment.broker}",
      layout: false
    )
  end

  def create
    model = params[:enrichmentable_type].constantize
    authorize model
    authorize Enrichment
    # Enrich one record
    if params[:enrichmentable_id]
      enrichmentable = model.find(params[:enrichmentable_id])
      EnrichService.call(enrichmentable, params[:broker_name])
    # Enrich several records
    elsif params[:enrichmentable_ids]
      params[:enrichmentable_ids].each do |id|
        enrichmentable = model.find(id)
        EnrichService.call(enrichmentable, params[:broker_name])
      end
    end
    respond_to do |format|
      format.js { render json: 'ok' }
    end
  end

  def destroy
    @enrichment = Enrichment.find(params[:id])
    @enrichmentable = @enrichment.enrichmentable
    authorize @enrichmentable
    @enrichments = EnrichmentDecorator.wrap(
      @enrichmentable.enrichments.order(created_at: :desc)
    )
    set_useable_btokers
    message = if @enrichment.destroy
                { success: t('flashes.destroy', model: Enrichment.model_name.human) }
              # TODO: show translated (human) record name in error
              else
                { danger: @enrichment.errors.full_messages.join(', ') }
              end

    redirect_back(
      { fallback_location: enrichments_path}.merge message
    )
  end

  def set_useable_btokers
    @useable_brokers = BaseBroker.useable_brokers(@enrichmentable.content_format)
  end
end
