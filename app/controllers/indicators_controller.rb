# frozen_string_literal: true

class IndicatorsController < ApplicationController
  include RecordOfOrganization

  before_action :set_investigation, only: [:new]

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

  def create
    @record = model.new(record_params)
    authorize @record.class
    if params[:indicator][:indicators_list].present?
      CreateIndicatorsService.call(
        params[:indicator][:indicators_list],
        @record.investigation_id,
        current_user.id
      )
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
end
