# frozen_string_literal: true

class VulnerabilitiesController < ApplicationController
  include Record
  include ReadableRecord

  before_action :set_time, only: [:create, :update]

  autocomplete(
    :vulnerability,
    :codename
  )

  def search
    index
    render 'index'
  end

  def toggle_processed
    vulnerability = record
    authorize vulnerability.class
    vulnerability.toggle(:processed)
    vulnerability.processed_by_id = current_user.id
    vulnerability.save
    @record = VulnerabilityDecorator.new(vulnerability.reload)
    set_readable_log
  end

  def toggle_custom_relevance
    vulnerability = record
    authorize vulnerability
    case vulnerability.custom_relevance
    when 'not_set'
      relevance = 'not_relevant'
    when 'relevant'
      relevance = 'not_set'
    else
      relevance = 'relevant'
    end
    vulnerability.custom_relevance = relevance
    vulnerability.updated_by_id = current_user.id
    vulnerability.save
    @record = VulnerabilityDecorator.new(vulnerability.reload)
    set_readable_log
  end

  private

  def model
    Vulnerability
  end

  def default_sort
    ['modified desc', 'id desc']
  end

  def set_time
    %w[published].each do |field|
    hours = params[:vulnerability]["#{field}_at(4i)"]
    minutes = params[:vulnerability]["#{field}_at(5i)"]
      if hours.present? && minutes.present?
        params[:vulnerability]["#{field}_time"] = '1'
      else
        params[:vulnerability]["#{field}_time"] = '0'
      end
    end
  end

  def set_custom_fields
    @custom_fields = CustomField.where(field_model: model.model_name.to_s)
  end

  def records_includes
    %i[processor]
  end

  def custom_prepare_ransack_params
    return unless params.dig(:q, :codename_in)
    params[:q][:codename_in] = params[:q][:codename_in].split("\n").map(&:strip)
  end

  def records_includes
    %i[vulnerability_kind
       processor
       vulnerability_bulletins
       vulnerability_bulletin_members]
  end
end
