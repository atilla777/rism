# frozen_string_literal: true

class IndicatorsController < ApplicationController
  include RecordOfOrganization
  include ReadableRecord

  before_action :set_investigation, only: [:new, :select, :reset, :paste]
  before_action :set_content_format, only: [:new, :create, :edit, :update]
  before_action :set_indicator_contexts, only: [:new, :create, :edit, :update]
  before_action :set_selected_indicator_contexts, only: [:new, :create, :edit, :update]

  before_action :set_edit_previous_page, only: %i[index show search tree_show]
  before_action :set_show_previous_page, only: %i[index search tree_show]

  def select
    authorize model
    set_selected_indicators
    redirect_back(fallback_location: root_path)
  end

  def reset
    authorize model
    session[:selected_indicators] = []
    redirect_back(fallback_location: root_path)
  end

  def paste
    if params[:indicator_id].present?
      indicator = Indicator.find(params[:indicator_id])
      authorize indicator
    else
      authorize model
      indicator = nil
    end
    paste_selected_indicators(indicator)
    redirect_back(fallback_location: root_path)
  end

  def search
    index
    @scope = params.dig(:q, :scope_eq) || params.dig(:scope)
  end

  def toggle_purpose
    indicator = record
    authorize indicator
    case indicator.purpose
    when 'not_set'
      purpose = 'for_detect'
    when 'for_detect'
      purpose = 'for_prevent'
    else
      purpose = 'not_set'
    end
    indicator.purpose = purpose
    indicator.current_user = current_user
    indicator.updated_by_id = current_user.id
    indicator.save
    @record = IndicatorDecorator.new(indicator.reload)
    set_readable_log
  end

  def toggle_trust_level
    indicator = record
    authorize indicator
    trust_level = case indicator.trust_level
                  when 'not_set'
                    'low'
                  when 'low'
                    'high'
                  else
                    'not_set'
                  end
    indicator.trust_level = trust_level
    indicator.current_user = current_user
    indicator.updated_by_id = current_user.id
    indicator.save
    @record = IndicatorDecorator.new(indicator.reload)
    set_readable_log
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
    @records = records(
      model.where(investigation_id: investigation_id)
    )
    @investigation = Investigation.find(investigation_id)
  end

  def tree_show
    authorize model
    investigation_id = params[:investigation_id]
    @investigation = Investigation.find(investigation_id)
    render 'tree'
  end

  def new
    @record = model.new(template_attributes)
    authorize @record.class
    @organization = organization
    preset_record
    @template_id = params[:template_id]
    set_format_errors
    set_parent_id
  end

  def create
    @record = model.new(record_params)
    authorize @record.class
    if @record.content.present? || @record.indicators_list.blank?
      @record.current_user = current_user
      @record.save!
      EnrichService.call(@record) if @record.enrich == '1'
    end
    if params[:indicator][:indicators_list].present?
      parent_indicator_id = if @record.content.present?
                              @record.id
                            elsif params[:indicators_list_parent_id].present?
                              params[:indicators_list_parent_id]
                            elsif params[:indicator][:parent_id].present?
                              params[:indicator][:parent_id]
                            else
                              nil
                            end

      unless create_indicators_from_list(parent_indicator_id)
        # TODO: why commented code don`t work?
        raise StandardError #ActiveRecord::RecordInvalid.new(@record)
      end
    end
    add_from_template
    #  indicators_path(investigation_id: @record.investigation_id),
    redirect_to(
      session.delete(:edit_return_to),
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue #ActiveRecord::RecordInvalid # TODO: see comment above
    @template_id = params[:template_id]
    unless @record.new_record?
      SetReadableLogService.call(@record, current_user)
      err = @record.errors
      @parent_id = @record.id
      @record = @record.dup
      @record.content = nil
      @record.errors.copy!(err)
    end
    render :new
  end

  private

  def create_indicators_from_list(parent_indicator_id)
    @not_saved_strings = CreateIndicatorsService.call(
      params[:indicator][:indicators_list],
      @record.investigation_id,
      current_user.id,
      params[:indicator].fetch(:indicator_context_ids, []),
      @record.enrich,
      parent_indicator_id
    )
    if @not_saved_strings.present?
      @record.errors.add(:content, :wrong_format_or_dublication)
      false
    else
      true
    end
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

# TODO: delete (it dublicate code bellow)
#  def records_includes
#    %i[creator investigation]
#  end

  def default_sort
    'created_at desc'
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

  def paste_selected_indicators(indicator_to_paste)
    return if session[:selected_indicators].blank?
    indicators = Indicator.where(id: session[:selected_indicators].map(&:to_i))
    indicators.each do |indictor|
      next if indictor.id == indicator_to_paste&.id
      indictor.update_attributes(
        parent_id: indicator_to_paste&.id,
        current_user: current_user
      )
    end
    session[:selected_indicators] = []
  end

  def set_selected_indicators
    return unless params[:indicators_ids]
    session[:selected_indicators] ||= []
    session[:selected_indicators] += params[:indicators_ids]
    session[:selected_indicators] = session[:selected_indicators].uniq
  end

  def set_parent_id
    @record.parent_id = params.fetch(:parent_id, nil)
  end

  def default_update_redirect_to
    redirect_to(
      session.delete(:edit_return_to),
      success: t('flashes.update', model: model.model_name.human)
    )
  end

  def records_includes
    %i[enrichments creator investigation]
  end
end
