# frozen_string_literal: true

class IndicatorsController < ApplicationController
  include RecordOfOrganization
  include ReadableRecord

  before_action :set_investigation, only: [:new]
  before_action :set_content_format, only: [:new, :create, :edit, :update]
  before_action :set_indicator_contexts, only: [:new, :create, :edit, :update]
  before_action :set_selected_indicator_contexts, only: [:new, :create, :edit, :update]

  def search
    index
    @scope = params.dig(:q, :scope_eq) || params.dig(:scope)
  end

  def enrich
    record = Indicator.find(params[:id])
    authorize record
    enrich_indicator(record)
  end

  def enrichment
    @indicator = Indicator.find(params[:id])
    authorize @indicator
    format = Indicator::Enrichments.map_hash_format(@indicator.content_format)
    service_name = Indicator::Enrichments.enrichment_by_name(params[:service_name])
    @enrichment = @indicator.enrichment.fetch(service_name)
    render "indicator_enrichments/#{format}_#{service_name}"
  end

  def index
    @associations = [:investigation]
    authorize model
    if params[:investigation_id].present? || params.dig(:q, :investigation_id_eq)
      index_for_investigation
    else
      index_for_all_investigations
    end
  end

  def index_for_all_investigations
    @records = records(model)
    render 'index_for_all_investigations'
  end

  def index_for_investigation
    investigation_id = if params[:investigation_id]
                         params[:investigation_id]
                       else
                         params[:q][:investigation_id_eq]
                       end
    @records = records(model.where(investigation_id: investigation_id))
    @investigation = Investigation.find(investigation_id)
  end

  def new
    @record = model.new(template_attributes)
    authorize @record.class
    @organization = organization
    preset_record
    @template_id = params[:template_id]
    set_format_errors
  end

  def create
    @record = model.new(record_params)
    authorize @record.class
    if params[:indicator][:indicators_list].present?
      @not_saved_strings = CreateIndicatorsService.call(
        params[:indicator][:indicators_list],
        @record.investigation_id,
        current_user.id,
        @record.enrich
      )
      if @not_saved_strings.present?
        @record.errors.add(:content, :wrong_format_or_dublication)
        raise ActiveRecord::RecordInvalid.new(@record)
      end
    else
      @record.current_user = current_user
      @record.save!
      enrich_indicator(@record) if @record.enrich == '1'
    end
    add_from_template
#    redirect_to(
#      session.delete(:edit_return_to),
#      success: t('flashes.create', model: model.model_name.human)
#    )
    redirect_to(
      indicators_path(investigation_id: @record.investigation_id),
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    @template_id = params[:template_id]
    render :new
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

  def set_return_to
    @return_to = {}
    @return_to[:label] = Investigation.model_name.human
    @return_to[:path] = indicators_path(investigation_id: @record.investigation.id)
  end

  def default_update_redirect_to
    redirect_to(
      indicators_path(investigation_id: @record.investigation_id),
      success: t('flashes.update', model: model.model_name.human)
    )
  end

  def model
    Indicator
  end

  def records_includes
    %i[organization creator investigation]
  end

  def default_sort
    'created_at desc'
  end

  def filter_for_organization
    model.where(organization_id: @organization.id)
  end
  def filter_for_organization
    model.joins('JOIN investigations ON investigations.id = indicators.investigation_id')
         .where('investigations.organization_id = ?', @organization.id)
  end

  def set_investigation
    @investigation = Investigation.find(params[:investigation_id])
  end

  def set_content_format
    @content_format = params[:content_format] || params.fetch(:indicator, {})
      .fetch(:content_format, nil)
  end

  def set_indicator_contexts
    #TODO: exclude record fetch dublication (here and in record of organization)
    content_format = @content_format \
      || Indicator.find_by(id: params[:id].to_i)&.content_format \
      || []
    @indicator_contexts = IndicatorContext
      .where(":content_format = ANY(indicators_formats)", content_format: content_format)
  end

  def set_selected_indicator_contexts
    @selected_indicator_contexts_ids = IndicatorContextMember.where(
      indicator_id: params[:id]
    ).pluck(:indicator_context_id)
  end

  def set_format_errors
    return unless params[:format_errors] == 'true'
    @record.errors.add(:content, :wrong_format_or_dublication)
    @not_saved_strings = params[:not_saved_strings]
  end
end
