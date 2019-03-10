# frozen_string_literal: true

class IndicatorsController < ApplicationController
  include RecordOfOrganization

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

  private

  def model
    Indicator
  end

#  def records_includes
#    %i[user]
#  end

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
end
