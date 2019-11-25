# frozen_string_literal: true

class InvestigationsController < ApplicationController
  include RecordOfOrganization
  include ReadableRecord

  def enrich
    investigation = Investigation.find(params[:id])
    authorize record
    investigation.indicators.each do |indicator|
      EnrichIndicatorService.call(indicator)
    end
  end

  def search
    index
    @scope = params.dig(:q, :scope_eq) || params.dig(:scope)
  end

  def create
    @record = model.new(record_params)
    authorize @record.class
    @organization = organization
    @record.current_user = current_user
    @record.save!
    # TODO: move to action after filter
    if params[:investigation][:indicators_list].present?
      @not_saved_strings = CreateIndicatorsService.call(
        params[:investigation][:indicators_list],
        @record.id,
        current_user.id,
        [],
        @record.enrich
      )
      if @not_saved_strings.present?
        redirect_to new_indicator_path(
          investigation_id: @record.id,
          not_saved_strings: @not_saved_strings,
          format_errors: true
        )
        return
      end
    else
      @record.current_user = current_user
      @record.save!
    end
    add_from_template
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization.id,
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    @template_id = params[:template_id]
    render :new
  end

  private

  def model
    Investigation
  end

  def records_includes
    %i[organization creator feed investigation_kind]
  end

  def default_sort
    'created_at desc'
  end
end
