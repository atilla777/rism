# frozen_string_literal: true

class IndicatorsController < ApplicationController
  include RecordOfOrganization

  before_action :set_investigation, only: [:new]
  before_action :set_content_format, only: [:new, :create, :edit, :update]
  before_action :set_indicator_subkinds, only: [:new, :create, :edit, :update]
  before_action :set_selected_indicator_subkinds, only: [:new, :create, :edit, :update]

  def index
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
        current_user.id
      )
      if @not_saved_strings.present?
        @record.errors.add(:content, :wrong_format_or_dublication)
        raise ActiveRecord::RecordInvalid.new(@record)
      end
    else
      @record.current_user = current_user
      @record.save!
    end
    add_from_template
    redirect_to(
      session.delete(:edit_return_to),
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    @template_id = params[:template_id]
    render :new
  end

  private

  def model
    Indicator
  end

  def records_includes
    %i[organization user investigation]
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

  def set_indicator_subkinds
    #TODO: exclude record fetch dublication (here and in record of organization)
    content_format = @content_format || Indicator.find(params[:id].to_i).content_format
    @indicator_subkinds = IndicatorSubkind
      .where(":indicator_format = ANY(indicators_kinds)", indicator_format: content_format)
  end

  def set_selected_indicator_subkinds
    @selected_indicator_subkind_ids = IndicatorSubkindMember.where(
      indicator_id: params[:id]
    ).pluck(:indicator_subkind_id)
  end

  def set_format_errors
    return unless params[:format_errors] == 'true'
    @record.errors.add(:content, :wrong_format_or_dublication)
    @not_saved_strings = params[:not_saved_strings]
  end
end
